module data_forwarding_unit (
    input [2:0] read_reg1,
    input [2:0] read_reg2,
    input [2:0] write_reg,
    input write_enable,
    input [7:0] write_data,
    output reg [7:0] forwarded_data1,
    output reg [7:0] forwarded_data2
);

    always @(*) begin
        // Default to zero if no forwarding occurs
        forwarded_data1 = 8'b0;
        forwarded_data2 = 8'b0;

        // Forwarding logic for the first read register
        if (write_enable && (write_reg == read_reg1)) begin
            forwarded_data1 = write_data; // Forward the data from write_data
        end

        // Forwarding logic for the second read register
        if (write_enable && (write_reg == read_reg2)) begin
            forwarded_data2 = write_data; // Forward the data from write_data
        end
    end
endmodule