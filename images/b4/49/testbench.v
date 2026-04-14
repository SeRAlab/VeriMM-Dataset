`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .sum(sum)
    );
    task testcase001;

        begin
            $display("Testcase 001: Zero Addition (0 + 0)");
            A = 32'h00000000;
            B = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Simple Addition (5 + 10)");
            A = 32'd5;
            B = 32'd10;
            #1;

            check_outputs(32'd15);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Identity Addition (Max + 0)");
            A = 32'hFFFFFFFF;
            B = 32'h00000000;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Overflow Wrap-around (Max + 1)");
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Mid-range Addition");
            A = 32'h12345678;
            B = 32'h87654321;
            #1;

            check_outputs(32'h99999999);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Bit Pattern Alternating A/5");
            A = 32'hAAAAAAAA;
            B = 32'h55555555;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Positive Boundary Carry (Max Int + 1)");
            A = 32'h7FFFFFFF;
            B = 32'h00000001;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Multiple Carry Propagation");
            A = 32'h0000FFFF;
            B = 32'h00000001;
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Negative Representation Addition (-1 + -1)");
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Large Hex Values");
            A = 32'hDEADBEEF;
            B = 32'h11111111;
            #1;

            check_outputs(32'hEFEFCE00);
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
        input [31:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
