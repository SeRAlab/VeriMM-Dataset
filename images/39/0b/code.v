module instruction_pipeline (
    input clk,
    input [4:0] instruction,
    output reg [2:0] stage
);

    // State definitions
    parameter FETCH = 3'b001;
    parameter DECODE = 3'b010;
    parameter EXECUTE = 3'b100;

    always @(posedge clk) begin
        case (stage)
            FETCH: stage <= DECODE;
            DECODE: stage <= EXECUTE;
            EXECUTE: stage <= FETCH;
            default: stage <= FETCH;
        endcase
    end

    // Initialize stage
    initial begin
        stage = FETCH;
    end

endmodule