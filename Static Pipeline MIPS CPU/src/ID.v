`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/08 16:38:18
// Design Name: 
// Module Name: ID
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/***************************************
ID��������ָ������������ź����ɣ��Լ��Ĵ�����ʵ����
***************************************/

module ID(
    /*********** input signal **************/
    input clk,
    input rst,
    input [31:0] pc_plus_4,//ָ���ַ
    input [31:0] inst,

    input [4:0] Ern,Mrn,//��ʱ��֪����ʲô��ð�ռ�⣿
    input Ew_rf,Mw_rf,Ew_hi,Mw_hi,Ew_lo,Mw_lo,//��ʱ��֪����ʲô��ð�ռ�⣿
    
    input [31:0] regfile_wdata,//regfiles input data
    input [31:0] hi_wdata,
    input [31:0] lo_wdata,//hi/lo input data
    input [4:0] regfile_waddress,//regfiles input address

    //write ena signal
    input regfile_wena,
    input hi_wena,
    input lo_wena,

    input EisGoto,//��֪����ɶ

    /*********** output signal **************/
    //pc address
    output [31:0] cpc,
    output [31:0] pc_regfiles,
    output [31:0] pc_branch,
    output [31:0] pc_jump,

    output [31:0] rs_data,
    output [31:0] rt_data,//regfiles outdata
    output [31:0] imm_data,//16λ��������չ���������
    output [31:0] CP0_data,//cp0 outdata
    output [31:0] hi_data,
    output [31:0] lo_data,//hi/lo outdata

    //output [31:0] id_pc_plus4,

    output [4:0] rn,//�Ĵ�����д�룿

    output sign,//����λ���
    output div,//������־�ź�
    output [3:0] aluc,//ALU�����ź�
    output o_w_hi,o_w_lo,o_w_rf,o_w_dm,//�����Ĵ������洢��д���ź�

    output alu_a_choose,alu_b_choose,//ALU�����ѡ��
    output [1:0] dmem_length_choose,//load/storeָ�����ݳ���

    output [1:0] hi_choose,
    output [1:0] lo_choose,//hi/lo����������ѡ���ź�
    output [2:0] regfile_choose,
    output [2:0] pc_choose,

    output stall,//�Ƿ�����ˮ����ͣ

    output isGoto//��ʱ��֪����ɶ
    //output [31:0] reg28 //��ʱ��֪����ɶ
    
    );

    /***********�����ź���****************/
    (*MARK_DEBUG="true"*) wire [5:0] op,func;//������
    (*MARK_DEBUG="true"*) wire [4:0] rsc,rtc,rdc;//regfiles��ַ��
    (*MARK_DEBUG="true"*) wire [15:0] inst_imm;//ָ���е�������
    (*MARK_DEBUG="true"*) wire sign_ext;//16bit��չ����λ��־
    (*MARK_DEBUG="true"*) wire is_lui;//LUI��־
    (*MARK_DEBUG="true"*) wire mfc0,mtc0,exception,eret;//cp0����
    //(*MARK_DEBUG="true"*) wire eret,is_teq,is_break,is_syscall��
    (*MARK_DEBUG="true"*) wire [31:0] status;
    //(*MARK_DEBUG="true"*) wire beq,bne,bgez;//�����ź�
    (*MARK_DEBUG="true"*) wire [1:0] request_branch;//��֧����
    (*MARK_DEBUG="true"*) wire is_branch;//�жϷ�֧���
    (*MARK_DEBUG="true"*) wire [4:0] cause;//�쳣ԭ��
    wire w_hi,w_lo,w_rf,w_dm;//�����Ĵ������洢��д���ź�
    
    wire [31:0] ext_18;//��֧��תƫ����
    wire  dm_cs;//dmemƬѡ

    assign func = inst[5:0];
    assign op = inst[31:26];
    assign rsc = inst[25:21];
    assign rtc = inst[20:16];
    assign rdc = inst[15:11];
    assign inst_imm = inst[15:0];

    assign pc_regfiles = rs_data;
    assign cpc = CP0_data;
    //assign id_pc_plus4 = pc_plus_4;

    II jpc(pc_plus_4[31:28],inst[25:0],pc_jump);


    /***********��ˮ����ͣ�ź���***********/
    reg [1:0] stall_count;//��¼��ͣʱ����
    wire [1:0] count_control_out;//�������������
    wire [1:0] count_control_in;//��������������



    S_Ext18 extend18(inst_imm,ext_18);
    //assign pc_branch = pc_plus_4 + ext_18;
    Add bpc(pc_plus_4,ext_18,pc_branch);

    //��֧Ԥ�⣬��ǰ�ж���ת
    ConfirmBranch confirm_branch(rs_data,rt_data,request_branch,is_branch);

 

    Ext_16 ext_immm(inst_imm,sign_ext,is_lui,imm_data);
    regfiles regfile_heap(clk,rst,regfile_wena,rsc,rtc,regfile_waddress,regfile_wdata,rs_data,rt_data);
    //assign cause = is_syscall ? 5'b01000 : (is_break ? 5'b01001 : (is_teq ? 5'b01101 : 5'b0));
    //assign exception = is_break || is_syscall || is_teq || eret;
    CP0 sccp0(clk,rst,mfc0,mtc0,pc_plus_4,regfile_wdata,exception,eret,cause,CP0_data,status,cpc);
    Reg HI(clk,rst,hi_wena,hi_wdata,hi_data);
    Reg LO(clk,rst,lo_wena,lo_wdata,lo_data);
    wire w_cp0;
    //������
    //compare
    wire [5:0] inst_num;
    DeInstruction de_ins(inst,inst_num);
    CPUControl cpu_ctrl(count_control_in,inst_num,rsc,rtc,rdc,is_branch,EisGoto,Ern,Mrn,Ew_rf,Mw_rf,Ew_hi,Mw_hi,Ew_lo,Mw_lo,/*Ew_cp0,Mw_cp0,*/1'b0,1'b0,stall,isGoto,count_control_out,
                        w_rf,w_cp0,w_hi,w_lo,w_dm,dm_cs,mfc0,mtc0,exception,eret,cause,regfile_choose,pc_choose,hi_choose,lo_choose,alu_a_choose,alu_b_choose,dmem_length_choose,
                        rn,aluc,sign,div,sign_ext,is_lui,request_branch);

    //��ˮ����ͣ����
    always @ (posedge stall)begin
        stall_count <= count_control_out;
    end

    /*����ָ���д�ź�*/
    assign o_w_dm = stall ? 1'b0 : w_dm;
    assign o_w_rf = stall ? 1'b0 : w_rf;
    assign o_w_hi = stall ? 1'b0 : w_hi;
    assign o_w_lo = stall ? 1'b0 : w_lo;

    always @ (negedge clk or posedge rst)begin
        if(rst) stall_count <= 2'b00;
        else begin
            if(stall_count != 2'b00)
                stall_count <= stall_count - 1;            
        end
    end
    assign count_control_in = stall_count;//����ͣ�������ݸ�������


endmodule
