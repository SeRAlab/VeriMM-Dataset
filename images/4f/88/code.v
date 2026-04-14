module top_module(
    input  wire [18:0] a,
    inout  wire [ 7:0] d,
    input  wire        ce_n,
    input  wire        oe_n,
    input  wire        we_n
);// ROM data
    reg [511:0] rom_data [0:63]; // Assuming 512 bytes for storage

    // write enable
    wire wr_en = ~we_n;

    // read enable
    wire rd_en = ~oe_n;

    // address
    wire [5:0] addr = a[8:3]; // Use upper bits for word addressing, adjust as necessary

    // read data
    assign d = rd_en ? rom_data[addr] : 8'bZZZZ_ZZZZ;

    // write data
    always @(posedge wr_en or negedge ce_n) begin
        if (!ce_n) begin
            // Chip select is active, ignore write
        end else if (wr_en) begin
            rom_data[addr] <= d;
        end
    end

endmodule