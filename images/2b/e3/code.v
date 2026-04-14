module virtual_memory_manager (
    input clk,
    input reset,
    input [31:0] virtual_address,
    output reg [31:0] physical_address
);
    reg [31:0] page_table [0:1023]; // 1024 page entries
    wire [11:0] page_number = virtual_address[31:20]; // 12 bits for page number
    wire [11:0] offset = virtual_address[11:0]; // 12 bits for offset

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            physical_address <= 32'b0;
        end else begin
            physical_address <= {page_table[page_number], offset};
        end
    end
endmodule