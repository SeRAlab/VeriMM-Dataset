module top_module(
    input clk,
    input rst,
    input [23:0] data_i,
    input [5:0] addr_i,
    input we_i,
    output reg [23:0] data_o,
    output reg [5:0] unread_ff
);reg [23:0] ram [63:0];
reg [5:0] read_ptr;
reg [5:0] write_ptr;

initial begin
    read_ptr = 6'd0;
    write_ptr = 6'd0;
    unread_ff = 6'd0;
end

always @(posedge clk) begin
    if (rst) begin
        read_ptr <= 6'd0;
        write_ptr <= 6'd0;
        unread_ff <= 6'd0;
    end else begin
        if (we_i) begin
            ram[write_ptr] <= data_i; // Use write_ptr instead of addr_i
            write_ptr <= write_ptr + 1;
            if (write_ptr == 6'd63) begin // Check against 63 instead of 64
                write_ptr <= 6'd0;
            end
            unread_ff <= unread_ff + 1;
        end

        data_o <= ram[read_ptr]; // Read data using read_ptr
        if (unread_ff > 0) begin
            unread_ff <= unread_ff - 1;
            read_ptr <= read_ptr + 1; // Move read pointer on every read
            if (read_ptr == 6'd63) begin // Check against 63 instead of 64
                read_ptr <= 6'd0; 
            end
        end
    end
end

endmodule