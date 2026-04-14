module binary_up_down_counter_3bit(
    input clk,
    input rst,
    input up_down,
    output reg [2:0] count
);

always @(posedge clk) begin
    if (rst) begin
        count <= 3'b000;
    end else if (up_down) begin
        count <= count + 1;
    end else begin
        count <= count - 1;
    end
end

endmodule