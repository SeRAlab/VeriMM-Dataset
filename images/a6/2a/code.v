module top_module(
    input [15:0] A,
    input [15:0] B,
    input mode,
    output reg negative
);reg [15:0] sum_reg;
reg [15:0] diff_reg;
reg [1:0] stage;
wire [15:0] A_reg;
wire [15:0] B_reg;
wire mode_reg;

assign A_reg = (stage == 0) ? A : sum_reg;
assign B_reg = (stage == 0) ? B : diff_reg;
assign mode_reg = (stage == 0) ? mode : 1'b1;

always @(*) begin
    case(stage)
        0: begin
            sum_reg = A + B;
            diff_reg = A - B;
        end
        1: begin
            sum_reg = A_reg + B_reg;
            diff_reg = A_reg - B_reg;
        end
        2: begin
            sum_reg = A_reg + B_reg;
            diff_reg = A_reg - B_reg;
        end
    endcase
end

always @(posedge mode_reg) begin
    if (stage == 2) begin
        negative <= (diff_reg[15] == 1);
        stage <= 0;
    end else begin
        stage <= stage + 1;
    end
end

endmodule