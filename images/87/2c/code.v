module top_module(
    input clk_i,
    input rst_i,
    input in_i,
    output reg out_o
);reg [1:0] state;
    parameter IDLE = 2'b00;
    parameter FOUND_0 = 2'b01;
    parameter FOUND_01 = 2'b10;

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            state <= IDLE;
            out_o <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    if (in_i == 1'b0) begin
                        state <= FOUND_0;
                    end
                end
                FOUND_0: begin
                    if (in_i == 1'b1) begin
                        state <= FOUND_01;
                    end else begin
                        state <= IDLE;
                    end
                end
                FOUND_01: begin
                    if (in_i == 1'b0) begin
                        state <= FOUND_0;
                        out_o <= 1'b0; // Reset output when moving to FOUND_0
                    end else begin
                        state <= IDLE;
                        out_o <= 1'b1; // Set output when detecting the sequence
                    end
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule