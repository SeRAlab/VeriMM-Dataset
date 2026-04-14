module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire [4:0] request,
    output reg [4:0] grant
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 5'b00000;
        end else begin
            case (1'b1)
                request[4]: grant <= 5'b00001; // Grant to input 4
                request[3]: grant <= 5'b00010; // Grant to input 3
                request[2]: grant <= 5'b00100; // Grant to input 2
                request[1]: grant <= 5'b01000; // Grant to input 1
                request[0]: grant <= 5'b10000; // Grant to input 0
                default: grant <= 5'b00000;     // No grant
            endcase
        end
    end
endmodule