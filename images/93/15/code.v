module top_module (
    input wire clk,
    output reg [2:0] count
);

    always @(posedge clk) begin
        count <= count + 1;
    end

endmodule