module shift_register_16bit
(
    input clk,
    input rst_n,
    input load,
    input [15:0] data_in,
    input serial_in,
    output reg [15:0] q
);

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        q <= 16'b0;
    end
    else if (load) begin
        q <= data_in;
    end
    else begin
        q <= {q[14:0], serial_in};
    end
end

endmodule