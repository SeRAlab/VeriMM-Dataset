module top_module(
    input [31:0] A,
    input [31:0] WD,
    input  WE,
    output reg [31:0] RD,  // Changed from wire to reg
    input  clk
);reg [31:0] mem [0:31];
reg [4:0] head = 0;

always @(posedge clk) begin
    if (WE) begin
        if (mem[A[6:2]] != 0) begin
            head <= head + 1;
            if (head == 32) begin
                head <= 0;
            end
        end
        mem[A[6:2]] <= WD;
    end
end

always @(posedge clk) begin
    if (!WE && (A[6:2] == head)) begin
        RD <= 0;
    end else begin
        RD <= mem[A[6:2]]; // Assign RD based on current memory value if not writing
    end
end

endmodule