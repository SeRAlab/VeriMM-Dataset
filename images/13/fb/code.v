module phase_shifter (
    input clk,
    input rst,
    input signal_in,
    input [2:0] phase_control,
    output reg signal_out
);
    reg [2:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            signal_out <= 0;
        end else begin
            if (counter < phase_control) begin
                counter <= counter + 1;
                signal_out <= signal_out; // Hold the previous output
            end else begin
                signal_out <= signal_in; // Output the input signal after phase shift
            end
            
            if (counter == 4) begin
                counter <= 0; // Reset counter after shifting
            end
        end
    end
endmodule