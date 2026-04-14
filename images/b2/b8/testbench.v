`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg S;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .S(S),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 32'hFFFF_FFFF;
        B = 32'h0000_0000;
        S = 1;
        $display("Test Case 001: Select A (S=1), All Ones");
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 32'hFFFF_FFFF;
        B = 32'h0000_0000;
        S = 0;
        $display("Test Case 002: Select B (S=0), All Zeros");
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 32'h1234_5678;
        B = 32'h8765_4321;
        S = 1;
        $display("Test Case 003: Select A (S=1), Specific Pattern");
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 32'h1234_5678;
        B = 32'h8765_4321;
        S = 0;
        $display("Test Case 004: Select B (S=0), Specific Pattern");
        #1;

        check_outputs(32'h8765_4321);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 32'hAAAA_AAAA;
        B = 32'h5555_5555;
        S = 1;
        $display("Test Case 005: Select A (S=1), Alternating Bits");
        #1;

        check_outputs(32'hAAAA_AAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 32'hAAAA_AAAA;
        B = 32'h5555_5555;
        S = 0;
        $display("Test Case 006: Select B (S=0), Alternating Bits");
        #1;

        check_outputs(32'h5555_5555);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 32'hDEAD_BEEF;
        B = 32'hCAFE_BABE;
        S = 1;
        $display("Test Case 007: Select A (S=1), Hex Pattern");
        #1;

        check_outputs(32'hDEAD_BEEF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 32'hDEAD_BEEF;
        B = 32'hCAFE_BABE;
        S = 0;
        $display("Test Case 008: Select B (S=0), Hex Pattern");
        #1;

        check_outputs(32'hCAFE_BABE);
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
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
