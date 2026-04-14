`timescale 1ns/1ps

module ALU_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] opcode;
    wire carry_out;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_8bit dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .carry_out(carry_out),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 8'hAA;
        B = 8'h55;
        opcode = 3'b000;
        $display("Test Case %0d: Opcode 000 (AND) - A=0xAA, B=0x55", test_num);
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 8'hF0;
        B = 8'h0F;
        opcode = 3'b001;
        $display("Test Case %0d: Opcode 001 (OR) - A=0xF0, B=0x0F", test_num);
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 8'hCC;
        B = 8'h33;
        opcode = 3'b010;
        $display("Test Case %0d: Opcode 010 (XOR) - A=0xCC, B=0x33", test_num);
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 8'h20;
        B = 8'h30;
        opcode = 3'b011;
        $display("Test Case %0d: Opcode 011 (ADD) - A=0x20, B=0x30", test_num);
        #1;

        check_outputs(1'b0, 8'h50);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 8'hFF;
        B = 8'h01;
        opcode = 3'b011;
        $display("Test Case %0d: Opcode 011 (ADD) - A=0xFF, B=0x01", test_num);
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 8'h50;
        B = 8'h20;
        opcode = 3'b100;
        $display("Test Case %0d: Opcode 100 (SUB) - A=0x50, B=0x20", test_num);
        #1;

        check_outputs(1'b0, 8'h30);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 8'h05;
        B = 8'h0A;
        opcode = 3'b100;
        $display("Test Case %0d: Opcode 100 (SUB) - A=0x05, B=0x0A", test_num);
        #1;

        check_outputs(1'b1, 8'hFB);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 8'hFF;
        B = 8'hFF;
        opcode = 3'b000;
        $display("Test Case %0d: Opcode 000 (AND) - A=0xFF, B=0xFF", test_num);
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_carry_out;
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, result=%h",
                         carry_out, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, result=%h",
                         expected_carry_out, expected_result);
                $display("  Got:      carry_out=%b, result=%h",
                         carry_out, result);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
