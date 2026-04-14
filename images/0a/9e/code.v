module pipeline_processor (
    input clk,
    input reset,
    input [31:0] instruction_in,
    output reg [31:0] instruction_out
);
    reg [2:0] current_state, next_state;
    parameter IF = 3'b000, ID = 3'b001, EX = 3'b010, MEM = 3'b011, WB = 3'b100;

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IF;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IF: next_state = ID;
            ID: next_state = EX;
            EX: next_state = MEM;
            MEM: next_state = WB;
            WB: next_state = IF; // Loop back to IF
            default: next_state = IF;
        endcase
    end

    always @(posedge clk) begin
        if (current_state == IF) begin
            instruction_out <= instruction_in; // Pass instruction to next stage
        end
    end
endmodule