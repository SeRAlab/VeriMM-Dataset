module top_module(
    input clk,
    input signed [3:0] A,
    input signed [3:0] B,
    output reg signed [7:0] P
);reg signed [3:0] A_reg, B_reg;
reg [2:0] count;
reg [7:0] P_reg;
reg [4:0] adder_input;

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
    
    if (count == 0) begin
        P_reg <= A_reg * B_reg;
        adder_input <= {P_reg[6], P_reg[5:0], 1'b0};
    end else begin
        if (adder_input[0] == 1 && adder_input[1] == 0) begin
            P_reg <= P_reg + (B_reg << count);
        end else if (adder_input[0] == 0 && adder_input[1] == 1) begin
            P_reg <= P_reg - (B_reg << count);
        end
        adder_input <= {P_reg[6], P_reg[5:0], adder_input[0]};
    end
    
    count <= count + 1;
end

assign P = P_reg;

endmodule