`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg io_enable;
    reg io_in;
    reg io_init;
    reg reset;
    wire io_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_enable(io_enable),
        .io_in(io_in),
        .io_init(io_init),
        .reset(reset),
        .io_out(io_out)
    );

        task reset_dut;

        begin
            @(posedge clock);
            reset = 1;
            io_enable = 0;
            io_in = 0;
            io_init = 0;
            @(posedge clock);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Reset...");
            reset_dut();


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Initialization (io_init)...");
            reset_dut();
            @(posedge clock);
            io_init = 1;
            @(posedge clock);
            io_init = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Data Load High...");
            reset_dut();
            @(posedge clock);
            io_enable = 1;
            io_in = 1;
            @(posedge clock);
            io_enable = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Data Load Low...");
            reset_dut();

            @(posedge clock);
            io_init = 1;
            @(posedge clock);
            io_init = 0;
            io_enable = 1;
            io_in = 0;
            @(posedge clock);
            io_enable = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Hold Value...");
            reset_dut();

            @(posedge clock);
            io_enable = 1;
            io_in = 1;
            @(posedge clock);

            io_enable = 0;
            io_in = 0;
            @(posedge clock);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Reset Priority...");
            reset_dut();
            @(posedge clock);
            reset = 1;
            io_init = 1;
            io_enable = 1;
            io_in = 1;
            @(posedge clock);
            reset = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Init Priority over Enable...");
            reset_dut();
            @(posedge clock);
            io_init = 1;
            io_enable = 1;
            io_in = 0;
            @(posedge clock);
            io_init = 0;
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
        input expected_io_out;
        begin
            if (expected_io_out === (expected_io_out ^ io_out ^ expected_io_out)) begin
                $display("PASS");
                $display("  Outputs: io_out=%b",
                         io_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_out=%b",
                         expected_io_out);
                $display("  Got:      io_out=%b",
                         io_out);
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
        $dumpvars(0,clock, io_enable, io_in, io_init, reset, io_out);
    end

endmodule
