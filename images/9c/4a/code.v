module shift_register_8bit (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [7:0] data_in,
    input wire serial_in,
    output reg [7:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 8'b0;
        end else if (load) begin
            q <= data_in;
        end else begin
            q <= {q[6:0], serial_in};
        end
    end
    
endmodule