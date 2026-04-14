module shift_register (
    input clk,
    input reset,
    input serial_in,
    input control,
    output reg [1:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 2'b00;
        end else begin
            if (control) begin
                // Shift left
                q <= {q[0], serial_in}; // Shift left and insert serial_in at LSB
            end else begin
                // Shift right
                q <= {serial_in, q[1]}; // Shift right and insert serial_in at MSB
            end
        end
    end
endmodule