module shift_register (
    input wire clk,
    input wire rstn,
    input wire load,
    input wire [7:0] data_in,
    input wire shift_in,
    output reg [7:0] data_out
);

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            data_out <= 8'b00000000;
        end else if (load) begin
            data_out <= data_in;
        end else begin
            data_out <= {data_out[6:0], shift_in};
        end
    end
    
endmodule