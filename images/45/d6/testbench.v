`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg io_enable;
    reg [31:0] io_in;
    reg [31:0] io_init;
    reg reset;
    wire [31:0] io_out;

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

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            io_enable = 0;
            io_in = 32'h0;
            io_init = 32'h0;
            #15;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Asynchronous Reset Initialization", test_num);
            io_init = 32'hDEADBEEF;
            io_enable = 0;
            io_in = 32'h12345678;


            reset = 1;
            #5;
            reset = 0;
            #5;

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Data Load (Enable=1)", test_num);
            reset_dut();

            @(posedge clock);
            io_enable <= 1;
            io_in <= 32'hA5A55A5A;

            @(posedge clock);
            #2;
            #1;

            check_outputs(32'hA5A55A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Enable Gating Check (Enable=0)", test_num);
            reset_dut();

            @(posedge clock);
            io_enable <= 0;
            io_in <= 32'hFFFFFFFF;

            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Data Hold Check", test_num);
            reset_dut();


            @(posedge clock);
            io_enable <= 1;
            io_in <= 32'h1234BCDE;


            @(posedge clock);
            io_enable <= 0;
            io_in <= 32'h0;

            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h1234BCDE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Reset Priority over Enable", test_num);
            reset_dut();

            @(posedge clock);
            io_enable <= 1;
            io_in <= 32'h88888888;
            io_init <= 32'h11111111;


            #2;
            reset = 1;
            #5;

            #1;


            check_outputs(32'h11111111);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Consecutive Writes", test_num);
            reset_dut();

            io_enable <= 1;
            @(posedge clock);
            io_in <= 32'h00000001;
            @(posedge clock);
            io_in <= 32'h00000002;
            @(posedge clock);
            io_in <= 32'h00000003;

            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h00000003);
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
        input [31:0] expected_io_out;
        begin
            if (expected_io_out === (expected_io_out ^ io_out ^ expected_io_out)) begin
                $display("PASS");
                $display("  Outputs: io_out=%h",
                         io_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_out=%h",
                         expected_io_out);
                $display("  Got:      io_out=%h",
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
