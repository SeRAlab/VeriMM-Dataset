module page_table_manager (
    input clk,
    input rst,
    input [31:0] virtual_address,
    input read_write,  // 0 for read, 1 for write
    output reg success,
    output reg page_fault,
    output reg [31:0] physical_address
);

reg [1:0] state, next_state;

// Define states
localparam IDLE = 2'b00;
localparam READ = 2'b01;
localparam WRITE = 2'b10;
localparam INVALIDATE = 2'b11;

// Dummy page table for demonstration (for 4 pages)
reg [31:0] page_table [0:3]; // Assuming 4 pages
reg valid [0:3]; // Page validity

// Initial values
initial begin
    valid[0] = 1; page_table[0] = 32'h00000001; // Page 0
    valid[1] = 1; page_table[1] = 32'h00000002; // Page 1
    valid[2] = 0; // Page 2 is invalid
    valid[3] = 1; page_table[3] = 32'h00000003; // Page 3
end

// State transition
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        success <= 0;
        page_fault <= 0;
        physical_address <= 0;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (read_write == 0) // read
                next_state = READ;
            else if (read_write == 1) // write
                next_state = WRITE;
            else
                next_state = IDLE;
        end
        READ: begin
            if (valid[virtual_address[31:30]]) begin
                physical_address = page_table[virtual_address[31:30]];
                success = 1;
                page_fault = 0;
                next_state = IDLE;
            end else begin
                success = 0;
                page_fault = 1;
                next_state = INVALIDATE;
            end
        end
        WRITE: begin
            if (valid[virtual_address[31:30]]) begin
                physical_address = page_table[virtual_address[31:30]];
                success = 1;
                page_fault = 0;
                next_state = IDLE;
            end else begin
                success = 0;
                page_fault = 1;
                next_state = INVALIDATE;
            end
        end
        INVALIDATE: begin
            success = 0;
            page_fault = 1;
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

endmodule