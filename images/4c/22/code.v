module down_counter_with_load (
    input wire clk,
    input wire ld,
    input wire [7:0] load_value,
    output reg [7:0] count
);
    
    always @(posedge clk or posedge ld) begin
        if (ld) begin
            count <= load_value;
        end else begin
            count <= count - 1;
        end
    end

endmodule