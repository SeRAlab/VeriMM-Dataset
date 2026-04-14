module top_module(
    input clk, 
    input reset, 
    input shift, 
    input [7:0] data_in, 
    output reg [7:0] data_out
);always @ (posedge clk) begin
        if (reset) begin
            data_out <= 8'h00;
        end else begin
            if (shift) begin
                data_out <= {data_in[0], data_out[7:1]};
            end else begin
                data_out <= {data_out[6:0], data_in[7]};
            end
        end
    end

endmodule