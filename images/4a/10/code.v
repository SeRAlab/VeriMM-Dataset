module top_module(
    input clk,
    input set,
    output reg [23:0] count
);

    // Always block triggered on the rising edge of the clock or the rising edge of set
    always @(posedge clk or posedge set) begin
        if (set) begin
            count <= 24'hFFFFFF;  // Asynchronous set to all ones
        end else begin
            count <= count + 1;  // Increment the counter
        end
    end

endmodule