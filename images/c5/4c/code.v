module up_down_counter (
    input clk,
    input reset,
    input control,
    output reg [2:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b0;
        end else if (control) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end

endmodule