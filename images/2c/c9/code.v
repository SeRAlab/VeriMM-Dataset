module ForwardingUnit (
    input [4:0] src1,
    input [4:0] src2,
    input [4:0] dest,
    input regWrite,
    output reg forwardA,
    output reg forwardB
);
    always @(*) begin
        // Initialize forwarding signals
        forwardA = 0;
        forwardB = 0;
        
        // Check if we should forward to src1
        if (regWrite && (dest != 0) && (dest == src1)) begin
            forwardA = 1; // Forward from EX/MEM to ID/EX
        end
        
        // Check if we should forward to src2
        if (regWrite && (dest != 0) && (dest == src2)) begin
            forwardB = 1; // Forward from EX/MEM to ID/EX
        end
    end
endmodule