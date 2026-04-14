module shift_register(
    input clk,
    input load,
    input [3:0] d,
    output reg [3:0] q
    );

    always @(posedge clk) begin
        if (load)
            q <= d; // Load parallel data
        else
            q <= {1'b0, q[3:1]}; // Shift right
    end
endmodule