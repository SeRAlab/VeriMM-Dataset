module timer_32bit (
    input wire clk,
    input wire rst,
    output reg [31:0] timer_value
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        timer_value <= 32'b0;
    end else begin
        timer_value <= timer_value + 1;
    end
end

endmodule