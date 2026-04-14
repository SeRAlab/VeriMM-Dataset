module ethernet_mac_controller (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    output reg [7:0] frame_count
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            frame_count <= 8'b0;
        end else begin
            frame_count <= frame_count + 1'b1;
        end
    end
endmodule