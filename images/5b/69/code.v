module top_module(
    clk,
    reset,
    shift_in,
    shift_out,
    edge_out
);parameter WIDTH = 4;

    input clk;
    input reset;
    input [WIDTH-1:0] shift_in;
    output [WIDTH-1:0] shift_out;
    output reg edge_out; // Change to reg type

    reg [WIDTH-1:0] shift_reg;
    reg edge_detected;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 0;
            edge_detected <= 0;
            edge_out <= 0; // Initialize edge_out during reset
        end else begin
            shift_reg <= {shift_reg[WIDTH-2:0], shift_in};
            if (!edge_detected && shift_reg[WIDTH-1] && !shift_reg[WIDTH-2]) begin
                edge_out <= 1;
                edge_detected <= 1;
            end else begin
                edge_out <= 0;
            end
        end
    end

    assign shift_out = shift_reg;

endmodule