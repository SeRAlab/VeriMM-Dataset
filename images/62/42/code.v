module updown_counter_3bit (
    input clk,
    input rst_n,
    input ctrl,
    output reg [2:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 3'b000;
    else if (ctrl)
        count <= count + 1;
    else
        count <= count - 1;
end

endmodule