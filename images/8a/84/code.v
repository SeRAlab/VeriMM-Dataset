module register_16(
   input                clk,
   input                enable,
   input                rst_n,
   input [15:0]         d,
 
   output reg [15:0]    q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) q <= 16'b0;
        else if (enable) q <= d;
    end

endmodule