module ring_counter (
    input clk,
    input reset,
    input load,
    input [4:0] load_value,
    output reg [4:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 5'b00001; // Initialize to '00001'
        end else if (load) begin
            count <= load_value; // Load the predefined value
        end else begin
            count <= {count[3:0], count[4]}; // Shift left
        end
    end
endmodule