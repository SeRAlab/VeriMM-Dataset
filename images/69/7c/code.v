module parallel_load_register(
   input                clk,
   input                rst_n,
   input                en,
   input      [31:0]    D,

   output reg [31:0]    Q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) Q <= 32'd0;
        else if (en) Q <= D;
    end
endmodule