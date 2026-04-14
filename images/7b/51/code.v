module top_module(
    input clk,
    input nreset,
    input WAIT,
    output reg [5:0] wait_random
);reg [8:0] wait_counter;

// This always block is for counting the wait time
always @(posedge clk or negedge nreset) begin
    if (!nreset) begin
        wait_counter <= 9'b0;
    end else begin
        wait_counter <= wait_counter + 1'b1;
    end
end

// This always block handles the random wait logic
always @(*) begin
    if (WAIT) begin
        wait_random = wait_counter[5:0]; // Assign the lower 6 bits of wait_counter
    end else begin
        wait_random = 6'b0; // Assign zero if WAIT is not asserted
    end
end

endmodule