module johnson_counter(
    input wire clk,
    input wire rst,
    input wire en,
    output reg [7:0] count
);

always @(posedge clk) begin
    if (~rst) begin
        count <= 8'b00000000;
    end else if (en) begin
        count <= {count[6:0], ~count[7]};
    end
end

endmodule