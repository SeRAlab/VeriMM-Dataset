module mux_4to1_with_forwarding (
    input [7:0] in0,
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    input [1:0] sel,
    input clk,
    output reg [7:0] out
);
    reg [7:0] last_out;

    always @(posedge clk) begin
        if (sel == 2'b00) begin
            out <= in0;
        end else if (sel == 2'b01) begin
            out <= in1;
        end else if (sel == 2'b10) begin
            out <= in2;
        end else if (sel == 2'b11) begin
            out <= in3;
        end

        if (out == last_out) begin
            out <= last_out; // Forward the last output
        end else begin
            last_out <= out; // Update last output
        end
    end
endmodule