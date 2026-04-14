module md5_simplified (
    input wire clk,
    input wire start,
    input wire [511:0] data,
    output reg [127:0] hash,
    output reg done
);

    reg [127:0] state;
    reg processing;
    
    initial begin
        state = 128'h0123456789abcdef0123456789abcdef; // Initial state
        done = 0;
        processing = 0;
    end

    always @(posedge clk) begin
        if (start && !processing) begin
            processing <= 1;
            // Simplified processing, just XOR with input for demonstration
            state <= state ^ data[127:0];
        end else if (processing) begin
            // Finalization step (simplified)
            hash <= state;
            done <= 1;
            processing <= 0;
        end
    end
endmodule