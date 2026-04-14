module shift_register_8bit (
    input wire clk,
    input wire load,
    input wire [7:0] data_in,
    input wire shift_in,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (load)
            q <= data_in;
        else
            q <= {q[6:0], shift_in};
    end

endmodule