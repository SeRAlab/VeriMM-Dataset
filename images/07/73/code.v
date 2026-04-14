module down_counter (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [3:0] preset,
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (rst) begin
            count <= 4'b0000;
        end else if (load) begin
            count <= preset;
        end else if (count > 0) begin
            count <= count - 1;
        end else begin
            count <= preset;
        end
    end
endmodule