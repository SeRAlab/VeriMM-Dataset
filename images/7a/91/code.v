module up_counter_4bit(
    input wire clk,
    input wire rst,
    output reg [3:0] count_out
    );

always @(posedge clk) begin
    if (rst) begin
        count_out <= 4'b0;
    end
    else begin
        count_out <= count_out + 1'b1;
    end
end

endmodule