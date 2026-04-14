module memory_allocator (
    input wire [7:0] request_size, // requested size in bytes (0-32)
    output reg success,            // allocation success flag
    output reg [4:0] address      // allocated address (0-31)
);
    reg [4:0] current_address;

    always @(*) begin
        if (request_size > 32) begin
            success = 0;           // allocation failed
            address = 5'b11111;    // invalid address
        end else begin
            success = 1;           // allocation successful
            address = current_address; // assign current address
            current_address = current_address + request_size; // increment address
            if (current_address >= 32) begin
                current_address = 0; // wrap around if exceeding memory
            end
        end
    end
endmodule