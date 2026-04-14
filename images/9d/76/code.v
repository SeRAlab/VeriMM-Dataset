module register_8bit (
    input wire clk,
    input wire clear,
    input wire enable,
    input wire [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk or posedge clear) begin
        if (clear) begin
            q <= 8'b00000000;
        end else if (enable) begin
            q <= d;
        end
    end

endmodule