module top_module(
    input clk,                 // clock
    input [11:0] instruction,  // instruction input
    input [15:0] datapath_in,  // data path input
    output [15:0] datapath_out, // data path output
    output [2:0] status        // status flag output
);reg [15:0] datapath_reg;       // data path register
reg [2:0] status_reg;          // status flag register

always @(posedge clk) begin
    case (instruction[11:8])
        4'b0000: begin          // Addition
            datapath_reg <= datapath_in[3:0] + datapath_in[7:4];
        end
        4'b0001: begin          // Subtraction
            datapath_reg <= datapath_in[3:0] - datapath_in[7:4];
        end
        4'b0010: begin          // Bitwise AND
            datapath_reg <= datapath_in[3:0] & datapath_in[7:4];
        end
        4'b0011: begin          // Bitwise OR
            datapath_reg <= datapath_in[3:0] | datapath_in[7:4];
        end
        4'b0100: begin          // Bitwise XOR
            datapath_reg <= datapath_in[3:0] ^ datapath_in[7:4];
        end
        4'b0101: begin          // Shift Left
            datapath_reg <= datapath_in[3:0] << datapath_in[7:4];
        end
        4'b0110: begin          // Shift Right
            datapath_reg <= datapath_in[3:0] >> datapath_in[7:4];
        end
        4'b0111: begin          // Load Immediate Value
            datapath_reg <= instruction[7:0];
        end
        default: begin          // Invalid Opcode
            datapath_reg <= 0;
        end
    endcase
    
    // Set status flag based on result
    if (datapath_reg == 0) begin
        status_reg <= 3'b001;   // Zero
    end else if (datapath_reg[15] == 1) begin
        status_reg <= 3'b100;   // Negative
    end else begin
        status_reg <= 3'b010;   // Positive
    end
end

assign datapath_out = datapath_reg;
assign status = status_reg;

endmodule