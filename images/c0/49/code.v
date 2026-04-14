module stratix_lvds_rx (
    rx_in,          
    rx_fastclk,     
    rx_enable0,
    rx_enable1,
    rx_out          
);
    parameter number_of_channels = 1;
    parameter deserialization_factor = 4;
    parameter REGISTER_WIDTH = deserialization_factor*number_of_channels;
    input [number_of_channels -1 :0] rx_in;
    input rx_fastclk;
    input rx_enable0;
    input rx_enable1;
    output [REGISTER_WIDTH -1: 0] rx_out;
    reg [REGISTER_WIDTH -1 : 0] rx_shift_reg;
    reg [REGISTER_WIDTH -1 : 0] rx_parallel_load_reg;
    reg [REGISTER_WIDTH -1 : 0] rx_out_hold;
    reg enable0_reg;
    reg enable0_reg1;
    reg enable0_neg;
    reg enable1_reg;
    wire rx_hold_clk;
    integer i1;
    integer x;
    initial
    begin : INITIALIZATION
        rx_shift_reg = {REGISTER_WIDTH{1'b0}};
        rx_parallel_load_reg = {REGISTER_WIDTH{1'b0}};
        rx_out_hold = {REGISTER_WIDTH{1'b0}};
    end 
    always @ (posedge rx_fastclk)
    begin : LOAD_ENABLE
        enable0_reg1 <= enable0_reg;
        enable0_reg <= rx_enable0;
        enable1_reg <= rx_enable1;
    end 
    always @ (negedge rx_fastclk)
    begin  : NEGEDGE_FAST_CLOCK
        if (enable0_neg == 1)
            rx_parallel_load_reg <= rx_shift_reg;
        for (i1= 0; i1 < number_of_channels; i1 = i1+1)
        begin
            for (x=deserialization_factor-1; x >0; x=x-1)
                rx_shift_reg[x + (i1 * deserialization_factor)] <=  rx_shift_reg [x-1 + (i1 * deserialization_factor)];
            rx_shift_reg[i1 * deserialization_factor] <= rx_in[i1];
        end
        enable0_neg <= enable0_reg1;
    end 
    always @ (posedge rx_hold_clk)
    begin : HOLD_REGISTER
        rx_out_hold <= rx_parallel_load_reg;
    end 
    assign rx_out = rx_out_hold;
    assign rx_hold_clk = enable1_reg;
endmodule