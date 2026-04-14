module top_module(
    input clk,              // Added clock input
    input reset,            // Added reset input
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] P     // Changed output to reg to store computed value
);reg [7:0] P_reg;
reg [3:0] A_reg, B_reg;
reg [2:0] count;

always @(posedge clk) begin
    if (reset) begin
        P_reg <= 8'b0;
        A_reg <= 4'b0;
        B_reg <= 4'b0;
        count <= 3'b0;
    end else begin
        P_reg <= {P_reg[6:0], P_reg[7]};
        case (count)
            3'b000: begin
                A_reg <= A;
                B_reg <= {B[3], B};
            end
            3'b001, 3'b010: begin
                if (B_reg[0] == 1) begin
                    P_reg <= P_reg + (A_reg << count);
                end
                B_reg <= {B_reg[3], B_reg[0]}; // Fixed shift operation
            end
            3'b011: begin
                if (B_reg[0] == 0) begin
                    P_reg <= P_reg + (A_reg << count);
                end
                B_reg <= {B_reg[3], B_reg[0]}; // Fixed shift operation
            end
            3'b100: begin
                if (B_reg[0] == 1) begin
                    P_reg <= P_reg + (A_reg << count);
                end
                B_reg <= {B_reg[3], B_reg[0]}; // Fixed shift operation
            end
        endcase
        count <= count + 1;
    end
end

assign P = P_reg;

endmodule