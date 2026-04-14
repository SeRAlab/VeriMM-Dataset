module shift_register (
    input serial_in,
    input shift,
    output reg [3:0] parallel_out
);

    always @ (posedge shift) begin
        parallel_out <= {parallel_out[2:0], serial_in};
    end

endmodule