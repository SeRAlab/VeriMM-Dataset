module down_counter(
    input wire clk,
    input wire clr,
    output reg [3:0] count
);

always @(posedge clk) begin
    if (clr) begin
        count <= 4'd15;
    end else begin
        count <= count - 4'd1;
    end
end

endmodule