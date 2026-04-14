module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [3:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000;
        end else if (up_down) begin
            if (count == 4'b1111) // max count is 15
                count <= count; // maintain current count
            else
                count <= count + 1;
        end else begin
            if (count == 4'b0000) // min count is 0
                count <= count; // maintain current count
            else
                count <= count - 1;
        end
    end
endmodule