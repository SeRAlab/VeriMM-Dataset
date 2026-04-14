module gpio_controller(
    input [3:0] data_in,
    input [1:0] ctrl,
    output reg [3:0] data_out
);
    always @(*) begin
        case (ctrl)
            2'b00: data_out = data_in;           // Output data as is
            2'b01: data_out = ~data_in;          // Output inverted data
            2'b10: data_out = data_in << 1;      // Shift data left
            2'b11: data_out = data_in >> 1;      // Shift data right
            default: data_out = 4'b0000;          // Default case
        endcase
    end
endmodule