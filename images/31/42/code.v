module phase_shifter (
    input wire clk,
    input wire rst,
    input wire din,
    input wire [1:0] phase_select,
    output reg dout
);
    reg [1:0] state;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dout <= 0;
            state <= 0;
        end else begin
            case (phase_select)
                2'b00: dout <= din;         // 0 degree phase shift
                2'b01: dout <= din;         // 90 degree phase shift, delayed by one clock cycle
                2'b10: dout <= {din, 1'b0}; // 180 degree phase shift, delayed by two clock cycles
                2'b11: dout <= {1'b0, din}; // 270 degree phase shift, delayed by three clock cycles
            endcase
        end
    end
endmodule