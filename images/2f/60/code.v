module binary_max_heap(
    input clk,
    input rst,
    input [7:0] insert_data,
    input insert_valid,
    input delete_max,
    output reg [7:0] max_out,
    output reg valid_out
);
    reg [7:0] heap [0:15];
    reg [3:0] size;
    reg [1:0] state;

    localparam IDLE = 2'b00, INSERT = 2'b01, DELETE = 2'b10, PEEK = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            size <= 0;
            valid_out <= 0;
            max_out <= 0;
            state <= IDLE;
        end
        else begin
            case (state)
                IDLE: begin
                    if (insert_valid) begin
                        heap[size] <= insert_data;
                        size <= size + 1;
                        state <= INSERT;
                    end
                    else if (delete_max) begin
                        size <= size - 1;
                        state <= DELETE;
                    end
                    else if (size > 0) begin
                        max_out <= heap[0];
                        valid_out <= 1;
                        state <= PEEK;
                    end
                end
                
                INSERT: begin
                    // Bubble up logic
                    // Implementation omitted for brevity
                    state <= IDLE;
                end
                
                DELETE: begin
                    // Bubble down logic
                    // Implementation omitted for brevity
                    state <= IDLE;
                end
                
                PEEK: begin
                    valid_out <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule