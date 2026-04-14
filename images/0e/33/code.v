module data_forwarding_unit (
    input [4:0] src1,
    input [4:0] src2,
    input [4:0] dst1,
    input [4:0] dst2,
    input write_enable,
    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);
    
    always @(*) begin
        // Default no forwarding
        forwardA = 2'b00;
        forwardB = 2'b00;

        if (write_enable) begin
            if (src1 == dst1) begin
                forwardA = 2'b01; // Forward from dst1
            end else if (src1 == dst2) begin
                forwardA = 2'b10; // Forward from dst2
            end
            
            if (src2 == dst1) begin
                forwardB = 2'b01; // Forward from dst1
            end else if (src2 == dst2) begin
                forwardB = 2'b10; // Forward from dst2
            end
        end
    end
endmodule