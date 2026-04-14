`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire AEQB;
    wire AGTB;
    wire ALTB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .AEQB(AEQB),
        .AGTB(AGTB),
        .ALTB(ALTB)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: A = B (Zero)");
        A = 4'b0000; B = 4'b0000;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: A = B (Max)");
        A = 4'b1111; B = 4'b1111;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: A > B (MSB differs)");
        A = 4'b1000; B = 4'b0111;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: A < B (MSB differs)");
        A = 4'b0111; B = 4'b1000;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: A > B (LSB differs)");
        A = 4'b1011; B = 4'b1010;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: A < B (LSB differs)");
        A = 4'b1010; B = 4'b1011;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: A = B (Pattern 1010)");
        A = 4'b1010; B = 4'b1010;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: A > B (Large difference)");
        A = 4'd15; B = 4'd0;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: A < B (Large difference)");
        A = 4'd0; B = 4'd15;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: Middle bits difference");
        A = 4'b0110; B = 4'b0101;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        testcase010();
        
        
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
        input expected_AEQB;
        input expected_AGTB;
        input expected_ALTB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AEQB === (expected_AEQB ^ AEQB ^ expected_AEQB) &&
                expected_AGTB === (expected_AGTB ^ AGTB ^ expected_AGTB) &&
                expected_ALTB === (expected_ALTB ^ ALTB ^ expected_ALTB)) begin
                $display("PASS");
                $display("  Outputs: AEQB=%b, AGTB=%b, ALTB=%b",
                         AEQB, AGTB, ALTB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AEQB=%b, AGTB=%b, ALTB=%b",
                         expected_AEQB, expected_AGTB, expected_ALTB);
                $display("  Got:      AEQB=%b, AGTB=%b, ALTB=%b",
                         AEQB, AGTB, ALTB);
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
