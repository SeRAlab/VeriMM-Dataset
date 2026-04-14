module pcie_endpoint_controller (
    input clk,
    input rst_n,
    input [31:0] addr,
    input rw, // 1 for read, 0 for write
    input [31:0] write_data,
    output reg valid,
    output reg [31:0] read_data
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid <= 0;
            read_data <= 32'b0;
        end else begin
            if (addr >= 32'h00000000 && addr <= 32'hFFFFFFFF) begin
                valid <= 1;
                if (rw) begin
                    // Read operation (dummy data for simulation)
                    read_data <= addr; // Just echo the address for demo purposes
                end else begin
                    // Write operation (store data)
                    // In a real design, you'd handle storing the data
                    read_data <= write_data; // For simulation, just return write_data
                end
            end else begin
                valid <= 0;
                read_data <= 32'b0;
            end
        end
    end
endmodule