module sd_card_controller (
    input wire clk,
    input wire [3:0] command,
    input wire [7:0] data_in,
    output reg status
);
    reg [7:0] data_out;
    
    always @(posedge clk) begin
        case (command)
            4'b0001: begin // Write data command
                data_out <= data_in;
                status <= 1'b1; // Operation successful
            end
            4'b0010: begin // Read data command
                data_out <= data_out; // Simulate reading data
                status <= 1'b1; // Operation successful
            end
            4'b0011: begin // Status command
                status <= 1'b0; // Indicate operation status
            end
            default: begin
                status <= 1'b0; // Operation failed
            end
        endcase
    end
endmodule