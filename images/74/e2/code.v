module up_down_counter_3bit (
    input clk,
    input reset,
    input control,
    output reg [2:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 3'b000;
        else if (control)
            count <= count + 1;
        else
            count <= count - 1;
    end

endmodule