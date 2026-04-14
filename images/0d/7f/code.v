module hmac (
    input wire [7:0] key,
    input wire [7:0] message,
    input wire start,
    output reg [7:0] hmac_out,
    output reg done
);
    reg [7:0] hash;

    always @(posedge start) begin
        // Simple hash function: XOR of key and message for demonstration
        hash <= key ^ message;
        done <= 1'b1; // Indicate that HMAC computation is done
        hmac_out <= hash;
    end
    
    // Reset done signal after one clock cycle
    always @(negedge start) begin
        done <= 1'b0;
    end
endmodule