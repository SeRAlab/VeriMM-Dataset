module Timer (
    input clk,
    input reset,
    input load,
    input [7:0] load_value,
    output reg [7:0] current_value
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_value <= 8'b0;
        end else if (load) begin
            current_value <= load_value;
        end else begin
            if (current_value < 8'hFF) begin
                current_value <= current_value + 1;
            end else begin
                current_value <= 8'b0; // Reset to 0 after max value
            end
        end
    end 
endmodule