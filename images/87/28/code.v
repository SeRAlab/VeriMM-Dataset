module top_module(
    input clk,
    input in_valid,
    input [15:0] in_data,
    input out_valid,
    output reg [15:0] out_data,  // Change to reg
    input reset
);localparam N = 16;

reg [15:0] array [0:N-1];
reg [3:0] read_pointer = 0;
reg [3:0] write_pointer = 0;
reg full = 0;
reg empty = 1;

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        read_pointer <= 0;
        write_pointer <= 0;
        full <= 0;
        empty <= 1;
    end else begin
        if (in_valid && !full) begin
            array[write_pointer] <= in_data;
            write_pointer <= write_pointer + 1;
            if (write_pointer == N - 1) begin  // Change to N - 1 for wrap-around
                write_pointer <= 0;
            end
            if (write_pointer + 1 == read_pointer) begin  // Must check the condition correctly
                full <= 1;
            end
            empty <= 0;
        end
        if (out_valid && !empty) begin
            out_data <= array[read_pointer];
            read_pointer <= read_pointer + 1;
            if (read_pointer == N - 1) begin  // Change to N - 1 for wrap-around
                read_pointer <= 0;
            end
            if (read_pointer + 1 == write_pointer) begin  // Must check the condition correctly
                empty <= 1;
            end
            full <= 0;
        end
    end
end

endmodule