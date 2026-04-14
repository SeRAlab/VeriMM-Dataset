module gray_code_counter (
    input wire clk,
    input wire rst,
    input wire en,
    output reg [1:0] q
);

    always @(posedge clk) begin
        if (rst) begin
            q <= 2'b00;
        end else if (en) begin
            case (q)
                2'b00: q <= 2'b01;
                2'b01: q <= 2'b11;
                2'b11: q <= 2'b10;
                2'b10: q <= 2'b00;
                default: q <= 2'b00;
            endcase
        end
    end

endmodule