`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset_n;
    reg scl;
    reg sda_in;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset_n(reset_n),
        .scl(scl),
        .sda_in(sda_in)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset_n = 0;
            scl = 1;
            sda_in = 1;
            repeat(2) @(posedge clock);
            reset_n = 1;
            repeat(2) @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge clock);
            scl = 1;
            sda_in = 1;
            repeat(2) @(negedge clock);
            sda_in = 0;
            repeat(2) @(negedge clock);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(negedge clock);
            scl = 1;
            sda_in = 0;
            repeat(2) @(negedge clock);
            sda_in = 1;
            repeat(2) @(negedge clock);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(negedge clock);
            scl = 0;
            sda_in = 0;
            repeat(2) @(negedge clock);
            sda_in = 1;
            repeat(2) @(negedge clock);
            scl = 1;
            repeat(2) @(negedge clock);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            @(negedge clock);
            scl = 1; sda_in = 1;
            repeat(2) @(negedge clock);
            sda_in = 0;
            repeat(2) @(negedge clock);


            scl = 0;
            repeat(2) @(negedge clock);
            sda_in = 0;
            repeat(2) @(negedge clock);
            scl = 1;
            repeat(2) @(negedge clock);
            sda_in = 1;
            repeat(2) @(negedge clock);

            #1;


            check_outputs(1'b0, 1'b1);
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
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clock, reset_n, scl, sda_in);
    end

endmodule
