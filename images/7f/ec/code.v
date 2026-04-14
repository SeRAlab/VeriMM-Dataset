module top_module(
    input clk,
    input reset_n,
    input [31:0] A,
    input [31:0] B,
    input [1:0] control,
    input start,
    output [31:0] C,
    output error
);reg [31:0] C_reg;
reg [31:0] A_reg;
reg [31:0] B_reg;
reg [1:0] control_reg;
reg start_reg;
reg [31:0] result_reg;
reg error_reg;

always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        C_reg <= 32'h0;
        A_reg <= 32'h0;
        B_reg <= 32'h0;
        control_reg <= 2'h0;
        start_reg <= 1'b0;
        error_reg <= 1'b0;
    end else begin
        C_reg <= result_reg;
        A_reg <= A;
        B_reg <= B;
        control_reg <= control;
        start_reg <= start;
        error_reg <= 1'b0;
        case(control_reg)
            2'h0: result_reg <= A_reg + B_reg;
            2'h1: result_reg <= A_reg - B_reg;
            2'h2: result_reg <= A_reg * B_reg;
            2'h3: begin
                    if(B_reg == 0) begin
                        error_reg <= 1'b1;
                        result_reg <= 32'h0;
                    end else begin
                        result_reg <= A_reg / B_reg;
                    end
                 end
        endcase
    end
end

assign C = C_reg;
assign error = error_reg;

endmodule