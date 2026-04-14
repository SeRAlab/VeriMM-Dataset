module pipo_shift_register (
    input wire clk,
    input wire load_en,
    input wire [4:0] data_in,
    output reg [4:0] data_out
);
    
    always @(posedge clk) begin
        if (load_en) begin
            data_out <= data_in;
        end
    end

endmodule