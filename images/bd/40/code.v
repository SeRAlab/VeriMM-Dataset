module shift_register (
    input clk,
    input load,
    input shift,
    input [7:0] data_in,
    output reg [7:0] data_out
);

    // Shift register logic
    always @(posedge clk) begin
        if (load)
            data_out <= data_in;
        else if (shift)
            data_out <= data_out >> 1;
    end

endmodule