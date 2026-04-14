`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg en_d;
    reg reset_n;
    wire frame_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .en_d(en_d),
        .reset_n(reset_n),
        .frame_en(frame_en)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset_n = 0;
            en_d = 0;
            repeat(2) @(posedge clock);
            #1;
            reset_n = 1;
            repeat(1) @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Countdown from 5", test_num);
            reset_dut();
            en_d = 1;
            repeat(5) @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Countdown with Pauses", test_num);
            reset_dut();
            en_d = 1;
            repeat(2) @(posedge clock);
            en_d = 0;
            repeat(5) @(posedge clock);
            en_d = 1;
            repeat(3) @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reload and frame_en Clear", test_num);
            reset_dut();
            en_d = 1;
            repeat(5) @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Long Reload Cycle (833,334 ticks)", test_num);
            reset_dut();
            en_d = 1;

            repeat(5) @(posedge clock);


            repeat(833334) @(posedge clock);
            #1;
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
        input expected_frame_en;
        begin
            if (expected_frame_en === (expected_frame_en ^ frame_en ^ expected_frame_en)) begin
                $display("PASS");
                $display("  Outputs: frame_en=%b",
                         frame_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_en=%b",
                         expected_frame_en);
                $display("  Got:      frame_en=%b",
                         frame_en);
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
        $dumpvars(0,clock, en_d, reset_n, frame_en);
    end

endmodule
