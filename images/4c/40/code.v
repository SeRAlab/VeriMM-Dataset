module binary_counter (
    input clk,
    input load,
    input reset,
    input [3:0] D,
    output reg [3:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 4'b0000;
        else if (load)
            count <= D;
        else
            count <= count + 1;
    end

endmodule