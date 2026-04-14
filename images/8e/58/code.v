module shift_register (
    input clk,
    input load,
    input [7:0] data_in,
    output reg [7:0] q
);

    // Shift register logic
    always @(posedge clk) begin
        if (load)
            q <= data_in;
        else
            q <= {q[6:0], 1'b0}; // Shift left
    end

endmodule