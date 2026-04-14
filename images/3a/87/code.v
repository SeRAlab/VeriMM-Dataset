module clock_gating(
    input wire clk,
    input wire enable,
    input wire data_in,
    output reg data_out
);

    wire gated_clk;
    
    // Clock gating logic
    assign gated_clk = clk & enable;

    // Sequential logic to update data_out
    always @(posedge gated_clk) begin
        data_out <= data_in;
    end

endmodule