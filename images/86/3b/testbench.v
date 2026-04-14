`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg temp_high;
    reg temp_low;
    wire ac_on;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .temp_high(temp_high),
        .temp_low(temp_low),
        .ac_on(ac_on)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            temp_high = 0;
            temp_low = 0;
            #15;
            areset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Power-on Reset", test_num);
            reset_dut();
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Off to On Transition", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            temp_high = 1;
            temp_low = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Stay in Off State", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            temp_high = 0;
            temp_low = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: On to Off Transition", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            temp_high = 1;
            @(posedge clk);
            #1;
            temp_high = 0;
            temp_low = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Stay in On State", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            temp_high = 1;
            @(posedge clk);
            #1;
            temp_high = 0;
            temp_low = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Off to On (Both inputs high)", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            temp_high = 1;
            temp_low = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: On to Off (Both inputs high)", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            temp_high = 1;
            @(posedge clk);
            #1;
            temp_high = 1;
            temp_low = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Asynchronous Reset while On", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            temp_high = 1;
            @(posedge clk);
            #2;
            areset = 1;
            #1;
            #1;

            check_outputs(0);
            areset = 0;
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
        input expected_ac_on;
        begin
            if (expected_ac_on === (expected_ac_on ^ ac_on ^ expected_ac_on)) begin
                $display("PASS");
                $display("  Outputs: ac_on=%b",
                         ac_on);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ac_on=%b",
                         expected_ac_on);
                $display("  Got:      ac_on=%b",
                         ac_on);
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
        $dumpvars(0,areset, clk, temp_high, temp_low, ac_on);
    end

endmodule
