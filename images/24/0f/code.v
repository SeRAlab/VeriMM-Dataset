module timer_16bit (
    input clk,
    input reset,
    input load,
    input [15:0] max_value,
    output reg done
);
    reg [15:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 16'b0;
            done <= 1'b0;
        end else if (load) begin
            count <= max_value;
            done <= 1'b0;
        end else if (count > 0) begin
            count <= count - 1;
            if (count == 1) begin
                done <= 1'b1;
            end
        end
    end
endmodule