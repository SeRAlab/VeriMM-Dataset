module fixed_priority_arbiter(
    input wire clk,
    input wire rst,
    input wire [4:0] request, // 5 request lines
    output reg [4:0] grant     // 5 grant lines
);

    // Priority encoding
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 5'b00000;
        end else begin
            casez (request)
                5'b1????: grant <= 5'b10000; // Request 0 has the highest priority
                5'b01???: grant <= 5'b01000; // Request 1
                5'b001??: grant <= 5'b00100; // Request 2
                5'b0001?: grant <= 5'b00010; // Request 3
                5'b00001: grant <= 5'b00001; // Request 4
                default:  grant <= 5'b00000;  // No grants
            endcase
        end
    end
endmodule