module binary_counter_with_load (
    input clk,
    input reset,
    input load,
    input [2:0] preset,
    output reg [2:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 3'b000;
        else if (load)
            count <= preset;
        else
            count <= count + 1;
    end

endmodule