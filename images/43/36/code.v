module top_module(
    input signed [31:0] A,
    input signed [31:0] B,
    input [1:0] ctrl,
    input rst,
    output reg signed [31:0] result,
    output reg flag
);always @ (ctrl or A or B or rst) begin
    if (rst) begin
        result <= 0;
        flag <= 0;
    end else begin
        case (ctrl)
            2'b00: result <= A + B;
            2'b01: result <= A - B;
            2'b10: result <= A * B;
            2'b11: begin
                if (B == 0) begin
                    flag <= 1;
                    result <= 0;
                end else begin
                    flag <= 0;
                    result <= A / B;
                end
            end
        endcase
    end
end

endmodule