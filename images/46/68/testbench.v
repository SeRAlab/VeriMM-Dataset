`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg data_in;
    reg reset_n;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data_in(data_in),
        .reset_n(reset_n),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset_n = 0;
            data_in = 0;
            #15;
            reset_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Rising Edge Detection", test_num);
            reset_dut();
            @(posedge clock);
            data_in <= 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pulse Duration Verification", test_num);
            reset_dut();
            @(posedge clock);
            data_in <= 1;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Falling Edge Detection", test_num);
            reset_dut();
            @(posedge clock);
            data_in <= 1;
            @(posedge clock);
            @(posedge clock);
            data_in <= 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sustained High Input", test_num);
            reset_dut();
            @(posedge clock);
            data_in <= 1;
            repeat(5) @(posedge clock);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asynchronous Reset During Pulse", test_num);
            reset_dut();
            @(posedge clock);
            data_in <= 1;
            @(posedge clock);
            #1;
            reset_n = 0;
            #2;
            #1;

            check_outputs(0);
            reset_n = 1;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Second Rising Edge Detection", test_num);
            reset_dut();
            @(posedge clock);
            data_in <= 1;
            @(posedge clock);
            data_in <= 0;
            @(posedge clock);
            data_in <= 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Signal Low Stability", test_num);
            reset_dut();
            data_in <= 0;
            repeat(3) @(posedge clock);
            #1;
            #1;

            check_outputs(0);
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
        input expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
                         data_out);
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
        $dumpvars(0,clock, data_in, reset_n, data_out);
    end

endmodule
