module top_module(
    input wire clk,
    input wire reset_n,
    input wire [7:0] data_in,
    output wire [7:0] data_out
);reg [7:0] processed_data;
    
    always @ (posedge clk) begin
        if (!reset_n) begin
            processed_data <= 8'b0;
        end else begin
            if (data_in < 8'h0A) begin
                processed_data <= data_in;
            end else if (data_in <= 8'h32) begin
                processed_data <= data_in * 2;
            end else begin
                processed_data <= data_in / 2;
            end
        end
    end
    
    assign data_out = processed_data;
    
endmodule