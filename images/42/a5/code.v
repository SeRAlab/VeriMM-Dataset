module shift_register_4bit (
    input clk,
    input serial_in,
    output reg [3:0] out
);

    // Shift register logic
    always @(posedge clk) begin
        out <= {out[2:0], serial_in};
    end

endmodule