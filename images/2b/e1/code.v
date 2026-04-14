module timer_16bit (
    input clk,
    input reset,
    input load,
    input [15:0] load_value,
    output reg [15:0] timer_out,
    output reg timer_done
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        timer_out <= 16'b0;
        timer_done <= 1'b0;
    end else if (load) begin
        timer_out <= load_value;
        timer_done <= 1'b0;
    end else if (timer_out > 0) begin
        timer_out <= timer_out - 1;
        if (timer_out == 1) begin
            timer_done <= 1'b1;
        end else begin
            timer_done <= 1'b0;
        end
    end else begin
        timer_done <= 1'b1; // Timer is done if it reaches zero
    end
end

endmodule