module top_module(
    input [3:0] A,
    input [3:0] B,
    input clk,        // Added input for clk
    output reg out
);reg [3:0] A_reg, B_reg;
reg [1:0] stage;

initial begin
    stage = 0;       // Initialize stage
end

always @(posedge clk) begin
    case(stage)
        2'b00: begin
            A_reg <= A;
            B_reg <= B;
            stage <= 2'b01;
        end
        2'b01: begin
            if (A_reg > B_reg) begin
                out <= 1;
            end else begin
                out <= 0;
            end
            stage <= 2'b00;
        end
    endcase
end

endmodule