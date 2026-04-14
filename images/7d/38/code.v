module top_module(
    input clk,
    input reset,
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] P
);reg [7:0] P_reg;
reg [4:0] A_reg, B_reg;
reg [2:0] counter;

always @(*) begin
    P_reg = A_reg * B_reg;  // This line seems to be unnecessary for Booth's algorithm.
end

always @(posedge clk) begin
    if (reset) begin
        A_reg <= 0;
        B_reg <= 0;
        P_reg <= 0;
        counter <= 0;
        P <= 0;  // Initialize P to 0
    end else begin
        case (counter)
            3'b000: begin
                A_reg <= {1'b0, A};   // Extend A to 5 bits
                B_reg <= {1'b0, B};   // Extend B to 5 bits
                P_reg <= 0;           // Initialize P_reg to 0
            end
            3'b001, 3'b010: begin
                if (B_reg[0] == 1) begin
                    P_reg <= P_reg - A_reg;
                end else begin
                    P_reg <= P_reg + A_reg;
                end
                A_reg <= A_reg << 1;   // Shift A_reg left
                B_reg <= B_reg >> 1;   // Shift B_reg right
            end
            3'b011: begin
                P <= P_reg;            // Assign the computed product to P
            end
        endcase
        counter <= counter + 1;  // Increment the counter
    end
end

endmodule