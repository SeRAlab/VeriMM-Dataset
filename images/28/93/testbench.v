`timescale 1ns/1ps

module ALU_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [2:0] opcode;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_16bit dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Addition (0x1234 + 0x5678)", test_num);
        A = 16'h1234;
        B = 16'h5678;
        opcode = 3'b000;
        #1;

        check_outputs(16'h68AC);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Subtraction (0xABCD - 0x1234)", test_num);
        A = 16'hABCD;
        B = 16'h1234;
        opcode = 3'b001;
        #1;

        check_outputs(16'h9999);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Bitwise AND (0xFFFF & 0x0F0F)", test_num);
        A = 16'hFFFF;
        B = 16'h0F0F;
        opcode = 3'b010;
        #1;

        check_outputs(16'h0F0F);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Bitwise OR (0xAAAA | 0x5555)", test_num);
        A = 16'hAAAA;
        B = 16'h5555;
        opcode = 3'b011;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Bitwise XOR (0xFFFF ^ 0xAAAA)", test_num);
        A = 16'hFFFF;
        B = 16'hAAAA;
        opcode = 3'b100;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Addition Overflow (0xFFFF + 0x0001)", test_num);
        A = 16'hFFFF;
        B = 16'h0001;
        opcode = 3'b000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Subtraction Underflow (0x0000 - 0x0001)", test_num);
        A = 16'h0000;
        B = 16'h0001;
        opcode = 3'b001;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Bitwise AND with Zero (0x1234 & 0x0000)", test_num);
        A = 16'h1234;
        B = 16'h0000;
        opcode = 3'b010;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Bitwise XOR Self (0x1234 ^ 0x1234)", test_num);
        A = 16'h1234;
        B = 16'h1234;
        opcode = 3'b100;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_16bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
