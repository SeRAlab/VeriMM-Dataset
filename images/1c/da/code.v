module branch_predictor(
    input wire clk,
    input wire reset,
    input wire [1:0] predicted,
    input wire [1:0] actual,
    output reg [1:0] counter
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 2'b00; // Reset the counter to 00
        end else begin
            if (actual == 2'b01) begin // If branch taken
                if (counter < 2'b11)
                    counter <= counter + 1; // Increment the counter
            end else begin // If branch not taken
                if (counter > 2'b00)
                    counter <= counter - 1; // Decrement the counter
            end
        end
    end
endmodule