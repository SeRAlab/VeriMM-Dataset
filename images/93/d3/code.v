module top_module(
    input wire serial_in,
    input wire reset,
    output reg [7:0] parallel_out
);reg [2:0] state;
    reg [3:0] bit_count;
    reg [7:0] data_byte;
    
    always @(posedge serial_in) begin
        case(state)
            3'b000: begin // wait for start bit
                if(!serial_in) begin
                    state <= 3'b001;
                    bit_count <= 4'b0000;
                    data_byte <= 8'b00000000;
                end
            end
            3'b001: begin // read data bits LSB first
                data_byte[bit_count] <= serial_in;
                bit_count <= bit_count + 1;
                if(bit_count == 4'b1000) begin
                    state <= 3'b010;
                    bit_count <= 4'b0000;
                end
            end
            3'b010: begin // wait for stop bit
                if(serial_in) begin
                    parallel_out <= data_byte;
                    state <= 3'b000;
                end
            end
        endcase
    end
    
    always @(posedge reset) begin
        if(reset) begin
            parallel_out <= 8'b00000000;
            state <= 3'b000;
            bit_count <= 4'b0000;
            data_byte <= 8'b00000000;
        end
    end
    
endmodule