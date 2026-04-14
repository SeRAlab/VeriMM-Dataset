`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [31:0] time_dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .time_dout(time_dout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Verifying initial constant timestamp value", test_num);

            #10;
            #1;

            check_outputs(32'h5b310f03);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Verifying constant stability over time", test_num);

            #500;
            #1;

            check_outputs(32'h5b310f03);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Final verification before simulation end", test_num);
            #1000;
            #1;

            check_outputs(32'h5b310f03);
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
        input [31:0] expected_time_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_time_dout === (expected_time_dout ^ time_dout ^ expected_time_dout)) begin
                $display("PASS");
                $display("  Outputs: time_dout=%h",
                         time_dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: time_dout=%h",
                         expected_time_dout);
                $display("  Got:      time_dout=%h",
                         time_dout);
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
