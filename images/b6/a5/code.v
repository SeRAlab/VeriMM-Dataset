module async_counter (
    input clk,
    input enable,
    input reset,
    output reg [7:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 8'b00000000;
        else if (enable)
            count <= count + 1;
    end

endmodule