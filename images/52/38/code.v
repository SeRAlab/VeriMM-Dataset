module async_counter (
    input clk,
    input load,
    input enable,
    input reset,
    input [7:0] data,
    output reg [7:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 8'b00000000;
        else if (load)
            count <= data;
        else if (enable)
            count <= count + 1;
    end

endmodule