module ring_counter (
    input clk,
    input reset,
    output reg [4:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) 
            count <= 5'b00001; // Initialize the counter to 1
        else 
            count <= {count[3:0], count[4]}; // Rotate the bits
    end
endmodule