`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg d;
    reg x;
    reg y;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .x(x),
        .y(y),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        x = 0;
        forever #5 x = ~x;
    end

        task reset_dut;

        begin
            d = 0;
            y = 0;



            @(posedge x);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset check (posedge x)", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Latch d=1 on posedge y (x is low)", test_num);
            reset_dut();
            d = 1;

            wait(x == 0);
            #1;
            y = 1;
            #2;
            y = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Latch d=0 on posedge y (x is low)", test_num);
            reset_dut();

            d = 1;
            wait(x == 0); #1; y = 1; #1; y = 0;

            d = 0;
            wait(x == 0);
            #1;
            y = 1;
            #2;
            y = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset priority over previous latched value", test_num);
            reset_dut();

            d = 1;
            wait(x == 0); #1; y = 1; #1; y = 0;

            @(posedge x);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: posedge y ignored when x is high", test_num);
            reset_dut();
            d = 1;

            wait(x == 1);
            #1;
            y = 1;
            #2;
            y = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: q stability when y is stable", test_num);
            reset_dut();

            d = 1;
            wait(x == 0); #1; y = 1; #1; y = 0;

            d = 0;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset priority while y is high", test_num);
            reset_dut();
            d = 1;
            wait(x == 0); #1; y = 1;
            #1;
            @(posedge x);
            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
                         q);
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
        $dumpvars(0,d, x, y, q);
    end

endmodule
