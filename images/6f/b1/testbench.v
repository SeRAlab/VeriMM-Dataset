`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg toggle;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .toggle(toggle)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: System Reset/Idle", test_num);
            toggle = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single Toggle Pulse", test_num);

            toggle = 0;
            @(posedge clk);

            @(negedge clk) toggle = 1;
            @(posedge clk);

            @(negedge clk) toggle = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Sustained Toggle Assertion", test_num);

            toggle = 0;
            @(posedge clk);

            @(negedge clk) toggle = 1;
            repeat(3) @(posedge clk);

            @(negedge clk) toggle = 0;
            @(posedge clk);
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Rapid Toggle Sequence", test_num);

            toggle = 0;
            @(posedge clk);

            @(negedge clk) toggle = 1;
            @(posedge clk);
            @(negedge clk) toggle = 0;
            @(posedge clk);
            @(negedge clk) toggle = 1;
            @(posedge clk);
            @(negedge clk) toggle = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs();
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
