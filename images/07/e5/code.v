module wifi_module (
    input wire clk,
    input wire connect,
    output reg [1:0] status
);
    initial begin
        status = 0; // disconnected
    end

    always @(posedge clk) begin
        case (status)
            0: if (connect) status <= 1; // trying to connect
            1: if (connect) status <= 2; // connected
            2: if (!connect) status <= 0; // disconnect
        endcase
    end
endmodule