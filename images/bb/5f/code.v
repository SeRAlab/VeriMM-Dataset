module top_module(
    input clk,
    input rst_n,
    input write_en,
    input [7:0] write_addr,
    input [3:0] write_data,
    input read_en,
    input [7:0] read_addr,
    output reg [7:0] final_output
);// Define the RAM
    reg [3:0] ram [0:7];
    reg [3:0] read_data;

    // Define the D flip-flop
    reg [3:0] d_ff;
    always @(posedge clk) begin
        d_ff <= write_data;
    end

    // Write operation
    always @(posedge clk) begin
        if (write_en) begin
            ram[write_addr] <= write_data;
        end
    end

    // Read operation
    always @(posedge clk) begin
        if (read_en) begin
            read_data <= ram[read_addr];
        end
    end

    // Circular buffer architecture
    reg [7:0] internal_write_addr;
    reg [7:0] internal_read_addr;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            internal_write_addr <= 0;
            internal_read_addr <= 0;
        end else begin
            if (write_en) begin
                internal_write_addr <= (internal_write_addr + 1) % 8;
            end
            if (read_en) begin
                internal_read_addr <= (internal_read_addr + 1) % 8;
            end
        end
    end

    // Final output
    always @(posedge clk) begin
        final_output <= {d_ff, read_data};
    end

endmodule