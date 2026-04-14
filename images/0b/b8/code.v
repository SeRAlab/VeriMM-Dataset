module memory_allocator (
    input [3:0] request_size, // size requested (0 to 15)
    input request_malloc,      // malloc signal
    input request_free,        // free signal
    input [3:0] address,       // address to free
    output reg [3:0] alloc_address, // address allocated
    output reg error           // error signal
);

    reg [3:0] mem [0:15]; // memory allocation
    reg [3:0] alloc_ptr;  // current allocation pointer
    integer i;

    initial begin
        alloc_ptr = 0;
        alloc_address = 0;
        error = 1'b0;
        for (i = 0; i < 16; i = i + 1) begin
            mem[i] = 0; // initialize memory
        end
    end

    always @(*) begin
        if (request_malloc) begin
            if (alloc_ptr + request_size <= 16) begin
                alloc_address = alloc_ptr;
                alloc_ptr = alloc_ptr + request_size;
                error = 1'b0;
            end else begin
                alloc_address = 4'b1111; // -1 for error
                error = 1'b1;
            end
        end else if (request_free) begin
            if (address < alloc_ptr) begin
                // Logic to free up memory
                alloc_ptr = address; // Simplified free logic
                error = 1'b0;
            end else begin
                error = 1'b1; // Invalid free request
            end
        end else begin
            alloc_address = 4'b0000; // default if no request
            error = 1'b0;
        end
    end
endmodule