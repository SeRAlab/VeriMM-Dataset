module memory_allocator (
    input wire clk,
    input wire req, // request signal
    input wire [2:0] size, // size of memory to allocate (0-7)
    output reg allocated // allocation status
);
    reg [7:0] memory; // 8 bytes of memory
    reg [2:0] allocated_size;

    always @(posedge clk) begin
        if (req) begin // malloc
            if (size > 3'd0 && size <= 3'd8 && memory + size <= 8) begin
                memory <= memory + size;
                allocated_size <= size;
                allocated <= 1'b1; // allocation successful
            end else begin
                allocated <= 1'b0; // allocation failed
            end
        end else begin // free
            if (allocated_size > 0) begin
                memory <= memory - allocated_size;
                allocated_size <= 3'd0;
                allocated <= 1'b1; // deallocation successful
            end else begin
                allocated <= 1'b0; // nothing to free
            end
        end
    end
endmodule