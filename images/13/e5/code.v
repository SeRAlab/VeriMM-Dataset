module linked_list_traversal (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire [7:0] next_ptr_in,
    output reg [7:0] current_value,
    output reg done
);
    reg [7:0] current_ptr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_value <= 0;
            current_ptr <= 0;
            done <= 0;
        end else begin
            if (current_ptr == 0) begin
                current_value <= data_in;
                current_ptr <= next_ptr_in;
            end else if (next_ptr_in != 0) begin
                current_value <= data_in;
                current_ptr <= next_ptr_in;
            end else begin
                current_value <= 0;
                done <= 1;
            end
        end
    end
endmodule