module top_module(
    input signed [31:0] A,
    input signed [31:0] B,
    input clk,
    output signed [63:0] Y
);reg [31:0] A_reg;
reg [31:0] B_reg;
reg [1:0] state;
reg signed [63:0] Y_reg;
reg signed [63:0] Y_wire; // Change wire to reg

assign Y = Y_wire;

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
    case(state)
        2'b00: begin
            if(B_reg[0] == 1) begin
                Y_reg <= {32'h0, A_reg};
            end else begin
                Y_reg <= {32'h0, 32'h0};
            end
            state <= 2'b01;
        end
        2'b01: begin
            if(B_reg[0] == 1) begin
                Y_reg <= Y_reg - A_reg;
            end else begin
                Y_reg <= Y_reg + A_reg;
            end
            A_reg <= A_reg << 1;
            state <= 2'b10;
        end
        2'b10: begin
            B_reg <= B_reg >> 1;
            if(B_reg == 0) begin
                Y_wire <= Y_reg; // Now valid since Y_wire is reg
                state <= 2'b00;
            end else begin
                state <= 2'b01;
            end
        end
        default: begin
            state <= 2'b00;
        end
    endcase
end

endmodule