`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] io_input_data;
    reg io_input_enable;
    reg [31:0] io_input_init;
    reg io_input_reset;
    reg reset;
    wire [31:0] io_output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_input_data(io_input_data),
        .io_input_enable(io_input_enable),
        .io_input_init(io_input_init),
        .io_input_reset(io_input_reset),
        .reset(reset),
        .io_output_data(io_output_data)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        io_input_data = 32'h0;
        io_input_enable = 0;
        io_input_reset = 0;
        io_input_init = 32'h0;
        @(posedge clock);
        #1;
        reset = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Internal Reset with Init Value");
        io_input_init = 32'hA5A5A5A5;
        io_input_reset = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Data Loading with Enable");
        io_input_data = 32'h12345678;
        io_input_enable = 1;
        io_input_reset = 0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase003;

    begin
        reset_dut();

        io_input_data = 32'hBBBBBBBB;
        io_input_enable = 1;
        @(posedge clock);
        #1;

        io_input_enable = 0;
        io_input_data = 32'hFFFFFFFF;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'hBBBBBBBB);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: Reset Priority over Enable");
        io_input_init = 32'hCAFEFACE;
        io_input_data = 32'h11112222;
        io_input_reset = 1;
        io_input_enable = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'hCAFEFACE);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Simultaneous Reset Signals");
        io_input_init = 32'hD0D0D0D0;
        io_input_reset = 1;
        reset = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'hD0D0D0D0);
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
        input [31:0] expected_io_output_data;
        begin
            if (expected_io_output_data === (expected_io_output_data ^ io_output_data ^ expected_io_output_data)) begin
                $display("PASS");
                $display("  Outputs: io_output_data=%h",
                         io_output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_output_data=%h",
                         expected_io_output_data);
                $display("  Got:      io_output_data=%h",
                         io_output_data);
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
        $dumpvars(0,clock, io_input_data, io_input_enable, io_input_init, io_input_reset, reset, io_output_data);
    end

endmodule
