module binary_counter_4(
   input                clk,
   input                rst,

   output reg [3:0]     Q
);
    always@(posedge clk) begin
        if(rst) Q <= 4'b0000;
        else Q <= Q + 1;
    end
endmodule