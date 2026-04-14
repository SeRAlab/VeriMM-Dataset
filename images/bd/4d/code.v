module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    output [5:0] q
);reg [63:0] lfsr;
reg [3:0] binary_counter;
reg [1:0] active_counter;

always @(posedge clk) begin
    if (reset) begin
        lfsr <= 64'h1;
        binary_counter <= 4'h0;
        active_counter <= 2'h0;
    end else begin
        // LFSR Johnson counter
        lfsr <= {lfsr[62:0], lfsr[63] ^ lfsr[0] ^ lfsr[5] ^ lfsr[15]};
        
        // 4-bit binary counter
        if (active_counter == 2'h0) begin
            binary_counter <= binary_counter + 1;
            if (binary_counter == 4'hF) begin
                active_counter <= 2'h1;
            end
        end else begin
            binary_counter <= binary_counter - 1;
            if (binary_counter == 4'h0) begin
                active_counter <= 2'h0;
            end
        end
    end
end

assign q = (active_counter == 2'h0) ? binary_counter : {2'b00, ~binary_counter};

endmodule