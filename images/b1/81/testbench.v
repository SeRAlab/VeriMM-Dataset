`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] x1;
    wire [31:0] x2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x1(x1),
        .x2(x2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            x1 = 32'h00000000;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            x1 = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (A)", test_num);
            x1 = 32'hAAAAAAAA;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (5)", test_num);
            x1 = 32'h55555555;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking Hex Sequence", test_num);
            x1 = 32'hFEDCBA98;
            #1;

            check_outputs(32'h01234567);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit LSB", test_num);
            x1 = 32'h00000001;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit MSB", test_num);
            x1 = 32'h80000000;
            #1;

            check_outputs(32'h7FFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern 1", test_num);
            x1 = 32'h12345678;
            #1;

            check_outputs(32'hEDCBA987);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern 2", test_num);
            x1 = 32'hA5A5A5A5;
            #1;

            check_outputs(32'h5A5A5A5A);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern 3", test_num);
            x1 = 32'h0F0F0F0F;
            #1;

            check_outputs(32'hF0F0F0F0);
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
        input [31:0] expected_x2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_x2 === (expected_x2 ^ x2 ^ expected_x2)) begin
                $display("PASS");
                $display("  Outputs: x2=%h",
                         x2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x2=%h",
                         expected_x2);
                $display("  Got:      x2=%h",
                         x2);
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
