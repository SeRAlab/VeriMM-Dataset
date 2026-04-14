module dac_controller(
    input [23:0] din,
    input [4:0] gain,
    output reg dout
);
    wire [23:0] scaled_din;

    // Scale the input data by the gain factor
    assign scaled_din = din * gain;

    always @(*) begin
        // Assume threshold for output analog voltage is 12.5 (scaled accordingly)
        if (scaled_din > 12'd8192) // Assuming the reference voltage is 2^12
            dout = 1'b1; // Output is high if above threshold
        else
            dout = 1'b0; // Output is low if below threshold
    end
endmodule