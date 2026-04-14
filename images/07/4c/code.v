module counter_64bit (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [63:0] load_value,
    output reg [63:0] count
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 64'b0;
        end else if (load) begin
            count <= load_value;
        end else begin
            count <= count + 1;
        end
    end

endmodule