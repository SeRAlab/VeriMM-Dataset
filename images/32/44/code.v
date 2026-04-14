module rc_oscillator (
    input wire clk,
    input wire reset,
    output reg osc_out
);
    reg [3:0] count; // 4-bit counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            osc_out <= 0;
        end else begin
            if (count == 4'd15) begin // maximum count value
                osc_out <= ~osc_out; // toggle output
                count <= 0; // reset counter
            end else begin
                count <= count + 1; // increment counter
            end
        end
    end
endmodule