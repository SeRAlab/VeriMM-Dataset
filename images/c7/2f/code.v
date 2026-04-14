module up_counter_4bit_sync_reset (
    input clk,
    input rst,
    output reg [3:0] count
);

always @(posedge clk) begin
    if (rst == 1'b1) begin
        count <= 4'b0;
    end
    else begin
        count <= count + 1;
    end
end

endmodule