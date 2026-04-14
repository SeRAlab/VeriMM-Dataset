`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg PB_debounced;
    reg clock;
    wire PB_single_pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PB_debounced(PB_debounced),
        .clock(clock),
        .PB_single_pulse(PB_single_pulse)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            PB_debounced = 0;
            repeat(3) @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rising edge pulse detection", test_num);
            reset_dut();

            @(posedge clock);
            PB_debounced <= 1;

            @(posedge clock);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pulse duration check (Hold high)", test_num);
            reset_dut();

            @(posedge clock);
            PB_debounced <= 1;

            @(posedge clock);
            @(posedge clock);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Falling edge check", test_num);
            reset_dut();


            @(posedge clock);
            PB_debounced <= 1;
            repeat(2) @(posedge clock);


            PB_debounced <= 0;
            @(posedge clock);


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential pulses check", test_num);
            reset_dut();


            @(posedge clock);
            PB_debounced <= 1;
            repeat(2) @(posedge clock);


            PB_debounced <= 0;
            repeat(2) @(posedge clock);


            PB_debounced <= 1;
            @(posedge clock);


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Steady state low check", test_num);
            reset_dut();

            PB_debounced <= 0;
            repeat(5) @(posedge clock);

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
        input expected_PB_single_pulse;
        begin
            if (expected_PB_single_pulse === (expected_PB_single_pulse ^ PB_single_pulse ^ expected_PB_single_pulse)) begin
                $display("PASS");
                $display("  Outputs: PB_single_pulse=%b",
                         PB_single_pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PB_single_pulse=%b",
                         expected_PB_single_pulse);
                $display("  Got:      PB_single_pulse=%b",
                         PB_single_pulse);
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
        $dumpvars(0,PB_debounced, clock, PB_single_pulse);
    end

endmodule
