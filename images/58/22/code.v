module sync_johnson_counter_4bit(
    input wire clk,
    input wire rst,
    output reg [3:0] count
    );

always @(posedge clk) begin
    if (rst)
        count <= 4'b0000;
    else begin
        count[3] <= ~count[0];
        count[2] <= count[3];
        count[1] <= count[2];
        count[0] <= count[1];
    end
end

endmodule