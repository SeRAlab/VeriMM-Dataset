module top_module(
    input [3:0] M,
    input [3:0] N,
    input clk,            // Added the clock input
    output reg [7:0] P,
    output reg E
);reg [3:0] shift_reg;
reg [7:0] prod_reg;
reg [2:0] stage;        // Changed stage to a 3-bit register to accommodate stages 0-7

always @ (posedge clk) begin
    case (stage)
        3'b000: begin
            shift_reg <= N;
            prod_reg <= 0;
        end
        3'b001: begin
            shift_reg <= {shift_reg[2:0], 1'b0};
            prod_reg <= prod_reg + (shift_reg[0] ? M : 0); // Changed to add M to prod_reg if shift_reg[0] is 1
        end
        3'b010: begin
            shift_reg <= {shift_reg[2:0], 1'b0};
            prod_reg <= prod_reg + (shift_reg[0] ? M : 0);
        end
        3'b011: begin
            shift_reg <= {shift_reg[2:0], 1'b0};
            prod_reg <= prod_reg + (shift_reg[0] ? M : 0);
        end
        3'b100: begin
            shift_reg <= {shift_reg[2:0], 1'b0};
            prod_reg <= prod_reg + (shift_reg[0] ? M : 0);
        end
        3'b101: begin
            shift_reg <= {shift_reg[2:0], 1'b0};
            prod_reg <= prod_reg + (shift_reg[0] ? M : 0);
        end
        3'b110: begin
            shift_reg <= {shift_reg[2:0], 1'b0};
            prod_reg <= prod_reg + (shift_reg[0] ? M : 0);
        end
        3'b111: begin
            shift_reg <= {shift_reg[2:0], 1'b0};
            prod_reg <= prod_reg + (shift_reg[0] ? M : 0);
            P <= prod_reg;
            E <= (prod_reg[7] == 1) ? 1 : 0;
        end
    endcase
    stage <= (stage == 3'b111) ? 3'b000 : stage + 1; // Handle stage rollover
end

endmodule