module ring_counter_3bit(
    input wire clk,
    input wire rst,
    output reg [2:0] count
    );

always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 3'b001;
    else
        count <= {count[1:0], count[2]};
end

endmodule