module top_module(
    input logic CLK,
    input logic D,
    input logic DE,
    output logic Q
);always_ff @(posedge CLK) begin
        if (DE) begin
            Q <= D;
        end
    end

endmodule