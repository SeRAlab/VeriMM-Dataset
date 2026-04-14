module top_module(
    input wire clk,          // Added clk input
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);reg [15:0] input_reg;
    reg [7:0] upper_byte_reg;
    reg [7:0] lower_byte_reg;

    assign out_hi = upper_byte_reg;
    assign out_lo = lower_byte_reg;

    always @(posedge clk) begin
        input_reg <= in;
        upper_byte_reg <= input_reg[15:8];
        lower_byte_reg <= input_reg[7:0];
    end

endmodule