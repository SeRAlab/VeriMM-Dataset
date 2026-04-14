`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg data;
    wire to_pad;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .to_pad(to_pad)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Set input data to 0", test_num);
        data = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Set input data to 1", test_num);
        data = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Toggle data back to 0", test_num);
        data = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Toggle data back to 1", test_num);
        data = 1'b1;
        #1;

        check_outputs(1'b1);
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
        input expected_to_pad;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_to_pad === (expected_to_pad ^ to_pad ^ expected_to_pad)) begin
                $display("PASS");
                $display("  Outputs: to_pad=%b",
                         to_pad);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: to_pad=%b",
                         expected_to_pad);
                $display("  Got:      to_pad=%b",
                         to_pad);
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
