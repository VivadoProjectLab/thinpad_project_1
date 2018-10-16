`default_nettype none

module thinpad_top(
    input wire clk_50M,           //50MHz ʱ������
    input wire clk_11M0592,       //11.0592MHz ʱ������

    input wire clock_btn,         //BTN5�ֶ�ʱ�Ӱ�ť??�أ���������·������ʱΪ1
    input wire reset_btn,         //BTN6�ֶ���λ��ť??�أ���������·������ʱΪ1

    input  wire[3:0]  touch_btn,  //BTN1~BTN4����ť���أ�����ʱΪ1
    input  wire[31:0] dip_sw,     //32λ���뿪�أ�������ON��ʱ??1
    output wire[15:0] leds,       //16λLED�����ʱ1����
    output wire[7:0]  dpy0,       //����ܵ�λ�źţ�����С���㣬���1����
    output wire[7:0]  dpy1,       //����ܸ�λ�źţ�����С���㣬���1����

    //CPLD���ڿ�������??
    output wire uart_rdn,         //�������źţ�����??
    output wire uart_wrn,         //д�����źţ�����??
    input wire uart_dataready,    //��������׼��??
    input wire uart_tbre,         //��???���ݱ�??
    input wire uart_tsre,         //���ݷ�???��ϱ�??

    //BaseRAM�ź�
    inout wire[31:0] base_ram_data,  //BaseRAM���ݣ���8λ��CPLD���ڿ�������??
    output wire[19:0] base_ram_addr, //BaseRAM��ַ
    output wire[3:0] base_ram_be_n,  //BaseRAM�ֽ�ʹ�ܣ�����Ч�������ʹ���ֽ�ʹ�ܣ��뱣��??0
    output wire base_ram_ce_n,       //BaseRAMƬ???������??
    output wire base_ram_oe_n,       //BaseRAM��ʹ�ܣ�����??
    output wire base_ram_we_n,       //BaseRAMдʹ�ܣ�����??

    //ExtRAM�ź�
    inout wire[31:0] ext_ram_data,  //ExtRAM����
    output wire[19:0] ext_ram_addr, //ExtRAM��ַ
    output wire[3:0] ext_ram_be_n,  //ExtRAM�ֽ�ʹ�ܣ�����Ч�������ʹ���ֽ�ʹ�ܣ��뱣��??0
    output wire ext_ram_ce_n,       //ExtRAMƬ???������??
    output wire ext_ram_oe_n,       //ExtRAM��ʹ�ܣ�����??
    output wire ext_ram_we_n,       //ExtRAMдʹ�ܣ�����??

    //ֱ�������ź�
    output wire txd,  //ֱ�����ڷ�???��
    input  wire rxd,  //ֱ�����ڽ���??

    //Flash�洢���źţ���??? JS28F640 оƬ�ֲ�
    output wire [22:0]flash_a,      //Flash��ַ��a0����8bitģʽ��Ч??16bitģʽ����??
    inout  wire [15:0]flash_d,      //Flash����
    output wire flash_rp_n,         //Flash��λ�źţ�����Ч
    output wire flash_vpen,         //Flashд�����źţ��͵�ƽʱ���ܲ�������??
    output wire flash_ce_n,         //FlashƬ???�źţ�����??
    output wire flash_oe_n,         //Flash��ʹ���źţ�����??
    output wire flash_we_n,         //Flashдʹ���źţ�����??
    output wire flash_byte_n,       //Flash 8bitģʽѡ�񣬵���Ч����ʹ��flash??16λģʽʱ����??1

    //USB �������źţ���??? SL811 оƬ�ֲ�
    output wire sl811_a0,
    //inout  wire[7:0] sl811_d,     //USB�������������������dm9k_sd[7:0]����
    output wire sl811_wr_n,
    output wire sl811_rd_n,
    output wire sl811_cs_n,
    output wire sl811_rst_n,
    output wire sl811_dack_n,
    input  wire sl811_intrq,
    input  wire sl811_drq_n,

    //����������źţ���??? DM9000A оƬ�ֲ�
    output wire dm9k_cmd,
    inout  wire[15:0] dm9k_sd,
    output wire dm9k_iow_n,
    output wire dm9k_ior_n,
    output wire dm9k_cs_n,
    output wire dm9k_pwrst_n,
    input  wire dm9k_int,

    //ͼ������ź�
    output wire[2:0] video_red,    //��ɫ����??3??
    output wire[2:0] video_green,  //��ɫ����??3??
    output wire[1:0] video_blue,   //��ɫ����??2??
    output wire video_hsync,       //��ͬ����ˮƽͬ������??
    output wire video_vsync,       //��ͬ������ֱͬ������??
    output wire video_clk,         //����ʱ�����
    output wire video_de           //��������Ч�źţ�������������??
);

// 7���������������ʾ����number��16������ʾ�����������
reg[7:0] number;
SEG7_LUT segL(.oSEG1(dpy0), .iDIG(number[3:0])); //dpy0�ǵ�λ�����
SEG7_LUT segH(.oSEG1(dpy1), .iDIG(number[7:4])); //dpy1�Ǹ�λ�����

wire[1:0] state_number;
always @(state_number) begin
	number <= {6'b0,state_number};
end

ALU my_ALU(
    .clk(clock_btn),
    .rst(reset_btn),
    .input_data(dip_sw[15:0]),
    .output_data(leds[15:0]),
    .operation_data(dip_sw[3:0]),
    .state_number(state_number[1:0])
);


endmodule
