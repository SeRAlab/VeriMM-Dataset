module fifo_queue (
    input clk,
    input reset,
    input write_en,
    input read_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    reg [7:0] queue [3:0];  // 4 depth FIFO
    reg [1:0] write_pointer;
    reg [1:0] read_pointer;

    initial begin
        write_pointer = 2'b00;
        read_pointer = 2'b00;
        full = 0;
        empty = 1;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            write_pointer <= 2'b00;
            read_pointer <= 2'b00;
            full <= 0;
            empty <= 1;
        end else begin
            if (write_en && !full) begin
                queue[write_pointer] <= data_in;
                write_pointer <= write_pointer + 1;
                empty <= 0;
                if (write_pointer == 2'b11) begin
                    full <= 1;
                end
            end
            
            if (read_en && !empty) begin
                data_out <= queue[read_pointer];
                read_pointer <= read_pointer + 1;
                full <= 0;
                if (read_pointer == write_pointer) begin
                    empty <= 1;
                end
            end
        end
    end
endmodule