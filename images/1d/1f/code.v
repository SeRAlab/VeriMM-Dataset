module flash_memory_cell (
    input [1:0] control,
    input [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] memory;

    always @(*) begin
        case (control)
            2'b00: data_out = 5'b00000; // No operation
            2'b01: begin
                memory = data_in;        // Write operation
                data_out = memory;
            end
            2'b10: data_out = memory;   // Read operation
            2'b11: data_out = 5'b00000; // Invalid operation
            default: data_out = 5'b00000;
        endcase
    end
endmodule