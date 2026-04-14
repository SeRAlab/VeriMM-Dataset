module top_module( 
    input [3:0] code, // 4-digit binary code input
    output reg open // Output signal indicating whether the lock is open or not
);// Define the stored password
    reg [3:0] password [0:3];
    initial begin
        password[0] = 4'b1100;
        password[1] = 4'b1010;
        password[2] = 4'b0110;
        password[3] = 4'b0001;
    end
    
    // Define the control logic
    reg [1:0] state = 2'b00;
    always @ (code) begin
        case (state)
            2'b00: if (code != 4'b0000) state = 2'b01;
            2'b01: if (code != 4'b0000) state = 2'b10;
            2'b10: if (code == 4'b0000) state = 2'b00;
        endcase
    end
    
    // Define the output logic for matching passwords
    reg [3:0] selected_password;
    always @(state) begin
        case (state)
            2'b01: selected_password = password[0];
            2'b10: selected_password = password[1];
            default: selected_password = 4'b0000;
        endcase
    end

    // Define the output logic
    always @ (*) begin
        if (code == selected_password) open = 1'b1;
        else open = 1'b0;
    end

endmodule