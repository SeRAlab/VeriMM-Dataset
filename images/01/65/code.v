module memory_allocator(
    input clk,
    input allocate,
    input free,
    output reg [3:0] memory_status // 4 slots
);
    reg [3:0] allocated_slots;

    always @(posedge clk) begin
        if (allocate) begin
            allocated_slots <= allocated_slots + 1'b1;
        end
        if (free) begin
            allocated_slots <= allocated_slots - 1'b1;
        end
    end

    always @(*) begin
        memory_status = allocated_slots;
    end
endmodule