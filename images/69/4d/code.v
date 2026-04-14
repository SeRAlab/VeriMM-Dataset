module top_module(
    input clk,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);reg [3:0] q_reg1, q_reg2, q_reg3, q_reg4;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg1 <= 4'b0;
        q_reg2 <= 4'b0;
        q_reg3 <= 4'b0;
        q_reg4 <= 4'b0;
    end
    else begin
        q_reg1 <= q;
        q_reg2 <= q_reg1;
        q_reg3 <= q_reg2;
        q_reg4 <= q_reg3;
    end
end

reg [1:0] shift_amt;
reg [3:0] shifted_data;

always @(*) begin
    case (shift_amt)
        2'b00: shifted_data = q_reg1;
        2'b01: shifted_data = {q_reg1[0], q_reg2[3:1]}; // Fixed order to [3:1]
        2'b10: shifted_data = {q_reg1[0], q_reg2[3:2], q_reg3[2:1]}; // Fixed order to [3:2] and [2:1]
        2'b11: shifted_data = {q_reg1[0], q_reg2[3:2], q_reg3[2:1], q_reg4[3]}; // Fixed order to [3:2] and [3]
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
        shift_amt <= 2'b00;
    end
    else begin
        if (load) begin
            q <= data;
            shift_amt <= 2'b00;
        end
        else if (ena) begin
            shift_amt <= shift_amt + 1;
            q <= shifted_data;
        end
    end
end

endmodule