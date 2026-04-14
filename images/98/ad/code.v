module twos_complement_module(
    input wire clk,
    input wire reset,
    input wire [3:0] binary_num,
    output reg [3:0] twos_complement
);

    always @(posedge clk) begin
        if (reset) begin
            twos_complement <= 0;
        end else begin
            twos_complement <= ~binary_num + 1;
        end
    end

endmodule