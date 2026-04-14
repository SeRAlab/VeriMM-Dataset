module top_module(
    reset,
    clk,
    sel,
    in0,
    in1,
    in2,
    out);// Inputs
input reset;
input clk;
input [2:0] sel;
input in0;
input in1;
input in2;

// Outputs
output out;

reg out;

always @ (posedge clk) begin
    if (reset) begin
        out <= 1'b0;
    end else begin
        case (sel)
            3'b000: out <= in0;
            3'b001: out <= in1;
            3'b010: out <= in2;
            default: out <= 1'b0;
        endcase
    end
end

endmodule