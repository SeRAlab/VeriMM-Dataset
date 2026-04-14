module top_module(
    input clk,               // Added clk input
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] P
);reg [3:0] A_reg;
reg [3:0] B_reg;
reg [2:0] counter;
reg [4:0] P_reg;
reg [1:0] state;

always @(posedge clk) begin
    case (state)
        2'b00: begin
            A_reg <= A;
            B_reg <= B;
            counter <= 3'd4;
            P_reg <= 5'd0;
            state <= 2'b01;
        end
        2'b01: begin
            if (B_reg[0] == 1) begin
                P_reg <= P_reg + A_reg; // Fixed the addition/subtraction logic
            end else begin
                P_reg <= P_reg - A_reg;
            end
            B_reg <= {B_reg[3], B_reg[3:1]};
            state <= 2'b10;
        end
        2'b10: begin
            if (counter == 0) begin
                P <= P_reg;  // Consider correct width of P 
                state <= 2'b00;
            end else begin
                counter <= counter - 1;
                state <= 2'b01;
            end
        end
    endcase
end

endmodule