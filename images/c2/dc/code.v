module encryption_module (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire [15:0] key,
    output wire [7:0] data_out
);

    reg [7:0] shift_register = 8'h00;
    wire [7:0] xor_result;
    
    assign xor_result = data_in ^ key[7:0];
    
    always @(posedge clk) begin
        if (rst) begin
            shift_register <= 8'h00;
            data_out <= 8'h00;
        end
        else begin
            shift_register <= {shift_register[6:0], xor_result};
            data_out <= shift_register;
        end
    end
    
endmodule