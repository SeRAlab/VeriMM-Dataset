module instruction_pipeline (
    input wire clk,
    input wire reset,
    input wire [3:0] instruction_in,
    output reg [3:0] instruction_out,
    output reg [2:0] stage
);
    // Stage definitions
    localparam IF = 3'b000, ID = 3'b001, EX = 3'b010, MEM = 3'b011, WB = 3'b100;

    reg [3:0] instruction_reg [0:4]; // Pipeline registers

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instruction_out <= 4'b0000;
            stage <= IF;
        end else begin
            // Shift pipeline stages
            instruction_reg[4] <= instruction_reg[3];
            instruction_reg[3] <= instruction_reg[2];
            instruction_reg[2] <= instruction_reg[1];
            instruction_reg[1] <= instruction_reg[0];
            instruction_reg[0] <= instruction_in;

            // Advance the stage
            case (stage)
                IF: stage <= ID;
                ID: stage <= EX;
                EX: stage <= MEM;
                MEM: stage <= WB;
                WB: stage <= IF;
                default: stage <= IF;
            endcase

            // Output the current instruction at the WB stage
            if (stage == WB) begin
                instruction_out <= instruction_reg[4];
            end
        end
    end
endmodule