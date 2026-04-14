module top_module(
    input clk,
    input rst,
    input [5:0] op,
    output reg [2:0] state
    );always@(posedge clk) begin
        if (rst == 0) begin
            state <= 3'b000;
        end else begin
            case (state)
                3'b000: state <= 3'b001;
                3'b001: begin
                    if (op[5:3] == 3'b111) begin // j, jal, jr, halt
                        state <= 3'b000;
                    end else begin // others
                        state <= 3'b010;
                    end
                end
                3'b010: begin
                    if (op[5:2] == 4'b1101) begin // beq, bltz
                        state <= 3'b000;
                    end else if (op[5:2] == 4'b1100) begin // sw, lw
                        state <= 3'b100;
                    end else begin // others
                        state <= 3'b011;
                    end
                end
                3'b011: state <= 3'b000;
                3'b100: begin
                    if (op[0] == 1) begin // lw
                        state <= 3'b011;
                    end else begin
                        state <= 3'b000;
                    end
                end
            endcase
        end
    end

endmodule