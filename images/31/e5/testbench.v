`timescale 1ns/1ps

module Adder16Bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    wire [16:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Adder16Bit dut (
        .A(A),
        .B(B),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 16'h0000;
            B = 16'h0000;
            $display("Test Case %0d: Zero Addition (0 + 0)", test_num);
            #1;

            check_outputs(17'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 16'hFFFF;
            B = 16'hFFFF;
            $display("Test Case %0d: Maximum Values (65535 + 65535)", test_num);
            #1;

            check_outputs(17'h1FFFE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 16'hFFFF;
            B = 16'h0001;
            $display("Test Case %0d: Overflow Boundary (65535 + 1)", test_num);
            #1;

            check_outputs(17'h10000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 16'h8000;
            B = 16'h8000;
            $display("Test Case %0d: MSB Carry Out (0x8000 + 0x8000)", test_num);
            #1;

            check_outputs(17'h10000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 16'hAAAA;
            B = 16'h5555;
            $display("Test Case %0d: Alternating Bits (0xAAAA + 0x5555)", test_num);
            #1;

            check_outputs(17'h0FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 16'h1234;
            B = 16'h4321;
            $display("Test Case %0d: General Addition (0x1234 + 0x4321)", test_num);
            #1;

            check_outputs(17'h05555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 16'h0000;
            B = 16'hFFFF;
            $display("Test Case %0d: Identity Property (0 + 0xFFFF)", test_num);
            #1;

            check_outputs(17'h0FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 16'h1357;
            B = 16'h2468;
            $display("Test Case %0d: General Addition (0x1357 + 0x2468)", test_num);
            #1;

            check_outputs(17'h037BF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Adder16Bit Testbench");
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
        input [16:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Sum=%h",
                         Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Sum=%h",
                         expected_Sum);
                $display("  Got:      Sum=%h",
                         Sum);
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
