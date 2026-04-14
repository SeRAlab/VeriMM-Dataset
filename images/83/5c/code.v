module ring_counter_5bit(
    input wire clk,
    input wire rst,
    output reg [4:0] count
    );

always @(posedge clk) begin
    if (rst)
        count <= 5'b00001;
    else begin
        count <= {count[3:0], count[4]};
    end
end

endmodule