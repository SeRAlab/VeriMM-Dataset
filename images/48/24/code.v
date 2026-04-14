module top_module(
    input clk,
    input DMWr,
    input[6:0] index,
    input[31:0] din,
    output[31:0] dout
);reg[31:0] dmem[127:0];
   
    always @(posedge clk)
        if (DMWr)
        begin
            dmem[index] <= din;
        end
   
    assign dout = dmem[index];
    
endmodule