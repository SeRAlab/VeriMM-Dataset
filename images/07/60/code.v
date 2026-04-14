module two_bit_counter (
    input clk,
    input reset,
    input enable,
    output reg [1:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 2'b00;
        else if (enable)
            count <= count + 1;
    end
endmodule