module binary_counter_3bit(
    input clk,
    input reset_n,
    output reg [2:0] count
);
    always @(posedge clk) begin
        if (!reset_n)
            count <= 3'b000;
        else
            count <= count + 1;
    end
endmodule