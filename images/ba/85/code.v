module top_module(
    input clk,                 // Added clock input
    input rst,                 // Added reset input
    input [15:0] addr_port1,
    input [15:0] addr_port2,
    input [15:0] data_in_port1,
    input [15:0] data_in_port2,
    input write_en_port1,
    input write_en_port2,
    output [15:0] data_out_port1,
    output [15:0] data_out_port2,
    output error
);reg [15:0] ram [0:65535];
reg [15:0] data_out1, data_out2;
reg parity_in1, parity_in2, parity_out1, parity_out2;
reg [1:0] stage;
wire [15:0] data_in1, data_in2;
wire parity_check1, parity_check2;

assign data_in1 = {data_in_port1, parity_in1};
assign data_in2 = {data_in_port2, parity_in2};
assign parity_check1 = ^data_out1;
assign parity_check2 = ^data_out2;

always @(posedge clk) begin
    if (rst) begin
        stage <= 0;
        data_out1 <= 0;  // Reset data outputs
        data_out2 <= 0;  // Reset data outputs
        parity_out1 <= 0; // Reset parity outputs
        parity_out2 <= 0; // Reset parity outputs
    end else begin
        case (stage)
            0: begin // Read port 1
                data_out1 <= ram[addr_port1];
                parity_out1 <= ^data_out1;
                stage <= 1;
            end
            1: begin // Read port 2
                data_out2 <= ram[addr_port2];
                parity_out2 <= ^data_out2;
                stage <= 2;
            end
            2: begin // Write port 1
                if (write_en_port1) begin
                    ram[addr_port1] <= data_in1;
                    parity_in1 <= ^data_in1;
                end
                stage <= 3;
            end
            3: begin // Write port 2
                if (write_en_port2) begin
                    ram[addr_port2] <= data_in2;
                    parity_in2 <= ^data_in2;
                end
                stage <= 0;
            end
        endcase
    end
end

assign data_out_port1 = data_out1[15:0];
assign data_out_port2 = data_out2[15:0];

assign error = (parity_check1 != parity_out1) || (parity_check2 != parity_out2);

endmodule