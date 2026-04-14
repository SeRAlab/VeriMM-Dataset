module top_module(
    input i_CLK,
    input [2:0] i_TC,
    input [13:0] i_DATA,
    output [13:0] o_OUT
    );wire w_CLK;
    wire w_SFT;
    wire [13:0] w_DATA;
    reg [13:0] r_OUT = 14'd0;
    wire [2:0] w_TC;
    
    assign w_CLK = i_CLK;
    assign w_TC = i_TC;
    assign w_DATA = i_DATA;
    assign o_OUT = r_OUT;
    always@(posedge w_CLK)
    begin 
        if(w_TC == 3'd7)
            r_OUT = w_DATA >> 2'b11;
        else if(w_TC == 3'd4)
            r_OUT = w_DATA >> 2'b10;
        else if(w_TC == 3'd2)
            r_OUT = w_DATA >> 2'b01;
        else
            r_OUT = w_DATA >> 2'b00;
    end
endmodule