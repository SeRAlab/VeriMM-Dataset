module counter_4bit (
    input clk,
    input reset,
    output reg [3:0] count
);

    // Counter logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 4'b0000;
        else
            count <= count + 1;
    end

endmodule