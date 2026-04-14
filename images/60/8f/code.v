module top_module(
    output reg [31:0] padout,
    input [31:0] padin,
    input oe,
    input clk
);reg [31:0] padded_signal;
    reg [31:0] counter;

    always @(posedge clk) begin
        if (oe) begin
            padout <= padin;
            counter <= 0;
        end else begin
            if (counter == 0) begin
                padded_signal <= {padin, 16'h0};
            end
            padout <= padded_signal[counter+:32];
            counter <= counter + 1;
        end
    end
endmodule