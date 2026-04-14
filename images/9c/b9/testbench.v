`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg refclk;
    reg rst;
    wire locked;
    wire outclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .refclk(refclk),
        .rst(rst),
        .locked(locked),
        .outclk(outclk)
    );

    // Clock generation (10ns period)
    initial begin
        refclk = 0;
        forever #5 refclk = ~refclk;
    end

        task reset_dut;

        begin
            rst = 1;
            #100;
            rst = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking outputs during reset...", test_num);
            rst = 1;
            #50;

            #1;


            check_outputs(1'b0, 1'b0);
            rst = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking lock acquisition...", test_num);
            reset_dut();



            fork : lock_wait
                begin
                    wait(locked == 1'b1);
                    disable lock_wait;
                end
                begin
                    #2000;
                    disable lock_wait;
                end
            join


            #1;



            check_outputs(1'b1, outclk);
        end
        endtask

    task testcase003;

        time t1, t2;
        real period;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying outclk frequency (25MHz)...", test_num);
            reset_dut();

            wait(locked == 1'b1);


            @(posedge outclk);
            t1 = $time;
            @(posedge outclk);
            t2 = $time;

            period = t2 - t1;
            $display("  Measured Period: %0f ns", period);


            if (period >= 39.9 && period <= 40.1) begin
                #1;

                check_outputs(1'b1, outclk);
            end else begin
                $display("  Frequency mismatch! Expected 40ns period.");
                #1;

                check_outputs(1'b1, ~outclk);
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Relock after second reset...", test_num);


            reset_dut();
            wait(locked == 1'b1);
            #100;


            reset_dut();
            wait(locked == 1'b1);
            #50;

            #1;


            check_outputs(1'b1, outclk);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Long term stability...", test_num);
            reset_dut();

            wait(locked == 1'b1);


            #5000;


            #1;



            check_outputs(1'b1, outclk);
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
        input expected_locked;
        input expected_outclk;
        begin
            if (expected_locked === (expected_locked ^ locked ^ expected_locked) &&
                expected_outclk === (expected_outclk ^ outclk ^ expected_outclk)) begin
                $display("PASS");
                $display("  Outputs: locked=%b, outclk=%b",
                         locked, outclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: locked=%b, outclk=%b",
                         expected_locked, expected_outclk);
                $display("  Got:      locked=%b, outclk=%b",
                         locked, outclk);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,refclk, rst, locked, outclk);
    end

endmodule
