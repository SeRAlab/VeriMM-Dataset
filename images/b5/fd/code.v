module binary_counter_2bit (
    input clk,
    input enable,
    input reset,
    output reg [1:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 2'b00;
        else if (enable)
            count <= count + 1;
    end

endmodule