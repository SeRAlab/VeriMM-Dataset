module shift_register(
   input                clk,
   input                rst_n,
   input                load,
   input  [7:0]         D,

   output reg [7:0]     Q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) Q <= 8'b0;
        else if (load) Q <= D;
        else Q <= {1'b0, Q[7:1]};
    end
endmodule