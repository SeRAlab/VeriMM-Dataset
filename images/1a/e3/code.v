module zero_crossing_detector (
    input wire clk,
    input wire rst,
    input wire signal_in,
    output reg pulse_out
);
    reg previous_signal;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            previous_signal <= 0;
            pulse_out <= 0;
        end else begin
            if ((previous_signal === 1'b0 && signal_in === 1'b1) || 
                (previous_signal === 1'b1 && signal_in === 1'b0)) begin
                pulse_out <= 1;
            end else begin
                pulse_out <= 0;
            end
            previous_signal <= signal_in;
        end
    end
endmodule