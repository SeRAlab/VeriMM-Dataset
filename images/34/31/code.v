module data_forwarding_unit(
    input [4:0] src1,       // Source register 1 address
    input [4:0] src2,       // Source register 2 address
    input [4:0] dest,       // Destination register address
    input [31:0] data_out,  // Data from the destination register
    output reg [31:0] forwarded_data1, // Forwarded data for src1
    output reg [31:0] forwarded_data2  // Forwarded data for src2
);

always @(*) begin
    // Default outputs
    forwarded_data1 = 32'b0;
    forwarded_data2 = 32'b0;

    // Check for data hazard for src1
    if (src1 == dest) begin
        forwarded_data1 = data_out;
    end

    // Check for data hazard for src2
    if (src2 == dest) begin
        forwarded_data2 = data_out;
    end
end

endmodule