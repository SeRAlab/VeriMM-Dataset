module page_table_manager (
    input wire clk,
    input wire [3:0] page_number,
    input wire valid_bit,
    output reg valid_out,
    output reg [3:0] frame_number
);
    reg [3:0] page_table [0:15]; // 16 pages, each 4 bits for frame number
    reg [3:0] page_valid [0:15]; // Valid bits for each page

    always @(posedge clk) begin
        if (valid_bit) begin
            page_table[page_number] <= page_number; // Store page number as frame number for simplicity
            page_valid[page_number] <= 1; // Set valid bit
        end
    end

    always @(posedge clk) begin
        if (page_valid[page_number]) begin
            valid_out <= 1;
            frame_number <= page_table[page_number];
        end else begin
            valid_out <= 0;
            frame_number <= 4'b0000; // Default output if not valid
        end
    end
endmodule