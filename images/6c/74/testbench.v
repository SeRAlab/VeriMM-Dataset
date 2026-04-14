`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] right;
    wire [47:0] ouput;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .right(right),
        .ouput(ouput)
    );
    task testcase001;

        begin
            test_num = 1;
            right = 32'h00000000;
            #1;

            check_outputs(48'h000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            right = 32'hFFFFFFFF;
            #1;

            check_outputs(48'hFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            right = 32'hAAAAAAAA;
            #1;

            check_outputs(48'h555555555555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            right = 32'h55555555;
            #1;

            check_outputs(48'hAAAAAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            right = 32'h12345678;
            #1;

            check_outputs(48'h0A41A82AC3F0);
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
        input [47:0] expected_ouput;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ouput === (expected_ouput ^ ouput ^ expected_ouput)) begin
                $display("PASS");
                $display("  Outputs: ouput=%h",
                         ouput);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ouput=%h",
                         expected_ouput);
                $display("  Got:      ouput=%h",
                         ouput);
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
