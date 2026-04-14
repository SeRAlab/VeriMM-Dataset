`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (

    );
    task testcase001;

        begin
            reset = 1;
            increment_val = 3'd0;
            #20;
            reset = 0;
            #10;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            reset = 1; #10; reset = 0;
            increment_val = 3'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase003;

        begin
            reset = 1; #10; reset = 0;
            increment_val = 3'd2;
            @(posedge clk);
            increment_val = 3'd3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase004;

        begin
            reset = 1; #10; reset = 0;
            increment_val = 3'd4;
            @(posedge clk);
            increment_val = 3'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase005;

        begin
            reset = 1; #10; reset = 0;
            increment_val = 3'd3;
            @(posedge clk);
            increment_val = 3'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase006;

        begin
            reset = 1; #10; reset = 0;
            increment_val = 3'd7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase007;

        begin
            reset = 1; #10; reset = 0;
            increment_val = 3'd7;
            @(posedge clk);
            increment_val = 3'd7;
            @(posedge clk);
            increment_val = 3'd7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd5);
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
