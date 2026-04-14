module top_module(dout, din, strobe, clk);output reg dout;
input [7:0] din;
input strobe, clk;

reg [8:0] shift_reg = 0;  
                          
                          

always @(posedge clk) begin
    if (strobe)  
        shift_reg <= {din, ~^din};
    else  
        shift_reg <= {shift_reg[7:0], 1'b0};

    
    dout <= shift_reg[8];
end

endmodule