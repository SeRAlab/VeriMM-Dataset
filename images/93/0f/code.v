module top_module(
    input [3:0] A,
    input [3:0] B,
    input clk,
    output reg LT  // Change output to reg type
);reg [3:0] A_reg;
reg [3:0] B_reg;
reg [1:0] stage;

always @(posedge clk) begin
    case(stage)
        2'b00: begin
            A_reg <= A;
            B_reg <= B;
            stage <= 2'b01;
        end
        2'b01: begin
            if(A_reg > B_reg) begin
                LT <= 1'b0;  // Update LT as reg
            end else begin
                LT <= 1'b1;  // Update LT as reg
            end
            stage <= 2'b00; 
        end
    endcase
end

endmodule