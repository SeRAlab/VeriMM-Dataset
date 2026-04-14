module top_module(
    input CLK,
    input RST,
    input EN,
    output reg [2:0] Q
);// Implement the counter logic
    always @ (posedge CLK or posedge RST) begin
        if (RST) begin
            Q <= 3'b000; // Reset the counter
        end else if (EN) begin
            Q <= Q + 1; // Increment the counter
        end
    end

endmodule