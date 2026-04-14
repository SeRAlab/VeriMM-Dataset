`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] i0;
    reg [31:0] i1;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i0(i0),
        .i1(i1),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            i0 = 32'h00000000;
            i1 = 32'h00000000;
            $display("Test %0d: Zero Addition", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            i0 = 32'h00000005;
            i1 = 32'h0000000A;
            $display("Test %0d: Simple Addition (5 + 10)", test_num);
            #1;

            check_outputs(32'h0000000F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            i0 = 32'hFFFFFFFF;
            i1 = 32'h00000000;
            $display("Test %0d: Max Value + 0", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            i0 = 32'hFFFFFFFF;
            i1 = 32'h00000001;
            $display("Test %0d: Overflow Case (Wrap around)", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            i0 = 32'hAAAAAAAA;
            i1 = 32'h55555555;
            $display("Test %0d: Alternating Bits", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            i0 = 32'h12345678;
            i1 = 32'h87654321;
            $display("Test %0d: Arbitrary Values", test_num);
            #1;

            check_outputs(32'h99999999);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            i0 = 32'h80000000;
            i1 = 32'h80000000;
            $display("Test %0d: Most Significant Bit Carry", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            i0 = 32'h7FFFFFFF;
            i1 = 32'h7FFFFFFF;
            $display("Test %0d: Max Signed Positive Addition", test_num);
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            i0 = 32'hFFFFFFFF;
            i1 = 32'hFFFFFFFF;
            $display("Test %0d: All Ones Addition", test_num);
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            i0 = 32'h0000FFFF;
            i1 = 32'h00010000;
            $display("Test %0d: Boundary Carry", test_num);
            #1;

            check_outputs(32'h0001FFFF);
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
