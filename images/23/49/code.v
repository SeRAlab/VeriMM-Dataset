module saturating_counter(
    input wire clk,
    input wire reset,
    input wire branch_taken,
    output reg [1:0] counter
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 2'b00; // reset the counter to 0
        end else begin
            if (branch_taken) begin
                if (counter < 2'b11) counter <= counter + 1; // increment
            end else begin
                if (counter > 2'b00) counter <= counter - 1; // decrement
            end
        end
    end
endmodule