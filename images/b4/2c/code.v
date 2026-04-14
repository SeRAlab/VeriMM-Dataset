module sync_counter(
    input wire clk,
    input wire rst_n,
    input wire enable,
    output reg [2:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 3'b000;
    end else if (enable) begin
        count <= count + 1;
    end
end

endmodule