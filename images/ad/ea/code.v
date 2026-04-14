module binary_counter (
    input clk,
    input reset,
    output reg [3:0] count
);

    // 4-bit binary counter logic
    always @(posedge clk) begin
        if (reset)
            count <= 4'b0000;
        else
            count <= count + 1;
    end

endmodule