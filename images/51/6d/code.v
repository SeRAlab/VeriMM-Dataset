module shift_register(
    input clk,
    input load,
    input enable,
    input [3:0] data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (load)
            q <= data; // Load input data when load is high
        else if (enable)
            q <= {1'b0, q[3:1]}; // Shift right by one bit
    end

endmodule