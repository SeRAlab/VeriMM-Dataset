module top_module(
    input wire clk,
    input wire reset,
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);reg [7:0] reg_out;
    wire [7:0] shifter_out_hi;
    wire [7:0] shifter_out_lo;

    assign shifter_out_hi = in[15:8];
    assign shifter_out_lo = in[7:0];

    always @(posedge clk) begin
        if (reset) begin
            reg_out <= 8'b0;
        end else begin
            reg_out <= shifter_out_lo;
        end
    end

    assign out_hi = shifter_out_hi;
    assign out_lo = reg_out;

endmodule