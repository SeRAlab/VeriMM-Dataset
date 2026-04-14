`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [6:0] io_input_0_data;
    reg io_input_0_enable;
    reg io_input_0_reset;
    reg [6:0] io_input_1_data;
    reg io_input_1_enable;
    reg reset;
    wire [6:0] io_output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_input_0_data(io_input_0_data),
        .io_input_0_enable(io_input_0_enable),
        .io_input_0_reset(io_input_0_reset),
        .io_input_1_data(io_input_1_data),
        .io_input_1_enable(io_input_1_enable),
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
        io_input_0_data = 0;
        io_input_0_enable = 0;
        io_input_0_reset = 0;
        io_input_1_data = 0;
        io_input_1_enable = 0;
        @(posedge clock);
        #1;
        reset = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Global Reset");
        reset_dut();


        #1;



        check_outputs(7'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Load Input 0");
        reset_dut();
        io_input_0_data = 7'h5A;
        io_input_0_enable = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(7'h5A);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Load Input 1");
        reset_dut();
        io_input_1_data = 7'h25;
        io_input_1_enable = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(7'h25);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Local Input 0 Reset");
        reset_dut();

        io_input_1_data = 7'h7F;
        io_input_1_enable = 1;
        @(posedge clock);
        #1;

        if (io_output_data !== 7'h7F) $display("Setup failed for testcase004");


        io_input_1_enable = 0;
        io_input_0_reset = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Data Persistence");
        reset_dut();

        io_input_0_data = 7'h3C;
        io_input_0_enable = 1;
        @(posedge clock);
        #1;

        io_input_0_enable = 0;
        io_input_1_enable = 0;
        io_input_0_reset = 0;
        repeat(2) @(posedge clock);
        #1;

        #1;


        check_outputs(7'h3C);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Overwrite Input 0 with Input 1");
        reset_dut();

        io_input_0_data = 7'h11;
        io_input_0_enable = 1;
        @(posedge clock);
        #1;

        io_input_0_enable = 0;
        io_input_1_data = 7'hEE;
        io_input_1_enable = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(7'hEE);
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
        input [6:0] expected_io_output_data;
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
        $dumpvars(0,clock, io_input_0_data, io_input_0_enable, io_input_0_reset, io_input_1_data, io_input_1_enable, reset, io_output_data);
    end

endmodule
