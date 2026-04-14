`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [7:0] io_input_0_data;
    reg io_input_0_enable;
    reg io_input_0_reset;
    reg reset;
    wire [7:0] io_output_data;

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
        @(negedge clock);
        reset = 1;
        io_input_0_reset = 0;
        io_input_0_enable = 0;
        io_input_0_data = 8'h00;
        @(negedge clock);
        reset = 0;
        @(negedge clock);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic Data Load", test_num);
        reset_dut();

        io_input_0_enable = 1;
        io_input_0_data = 8'hA5;
        @(negedge clock);


        io_input_0_enable = 0;
        io_input_0_data = 8'h00;
        @(negedge clock);

        #1;


        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Enable Signal Logic", test_num);
        reset_dut();


        io_input_0_enable = 1;
        io_input_0_data = 8'h5A;
        @(negedge clock);


        io_input_0_enable = 0;
        io_input_0_data = 8'hFF;
        @(negedge clock);

        #1;


        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: External Reset Logic", test_num);
        reset_dut();


        io_input_0_enable = 1;
        io_input_0_data = 8'hCC;
        @(negedge clock);


        io_input_0_reset = 1;
        @(negedge clock);

        io_input_0_reset = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Reset Priority", test_num);
        reset_dut();


        io_input_0_enable = 1;
        io_input_0_data = 8'hEE;
        reset = 1;
        @(negedge clock);

        reset = 0;
        io_input_0_enable = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Consecutive Loads", test_num);
        reset_dut();

        io_input_0_enable = 1;
        io_input_0_data = 8'h11;
        @(negedge clock);

        io_input_0_data = 8'h22;
        @(negedge clock);

        io_input_0_data = 8'h33;
        @(negedge clock);

        #1;


        check_outputs(8'h33);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: External Reset Priority", test_num);
        reset_dut();


        io_input_0_enable = 1;
        io_input_0_data = 8'hAA;
        @(negedge clock);


        io_input_0_reset = 1;
        io_input_0_enable = 1;
        io_input_0_data = 8'hBB;
        @(negedge clock);

        io_input_0_reset = 0;
        io_input_0_enable = 0;
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_io_output_data;
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
        $dumpvars(0,clock, io_input_0_data, io_input_0_enable, io_input_0_reset, reset, io_output_data);
    end

endmodule
