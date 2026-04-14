`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg io_input_asyn_reset;
    reg io_input_reset;
    reg io_input_set;
    reg reset;
    wire io_output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_input_asyn_reset(io_input_asyn_reset),
        .io_input_reset(io_input_reset),
        .io_input_set(io_input_set),
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
        io_input_asyn_reset = 1;
        io_input_reset = 0;
        io_input_set = 0;
        reset = 0;
        #12;
        io_input_asyn_reset = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Synchronous Set", test_num);
        io_input_set = 1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Synchronous Reset (io_input_reset)", test_num);

        io_input_set = 1;
        @(posedge clock);
        #1;

        io_input_set = 0;
        io_input_reset = 1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Global Synchronous Reset", test_num);

        io_input_set = 1;
        @(posedge clock);
        #1;

        io_input_set = 0;
        reset = 1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Asynchronous Reset Precedence", test_num);

        io_input_set = 1;
        @(posedge clock);
        #2;


        io_input_asyn_reset = 1;
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Synchronous Reset Priority Over Set", test_num);

        io_input_set = 1;
        io_input_reset = 1;
        @(posedge clock);
        #2;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Hold State", test_num);

        io_input_set = 1;
        @(posedge clock);
        #1;

        io_input_set = 0;
        io_input_reset = 0;
        reset = 0;
        @(posedge clock);
        #2;

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
        input expected_io_output_data;
        begin
            if (expected_io_output_data === (expected_io_output_data ^ io_output_data ^ expected_io_output_data)) begin
                $display("PASS");
                $display("  Outputs: io_output_data=%b",
                         io_output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_output_data=%b",
                         expected_io_output_data);
                $display("  Got:      io_output_data=%b",
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
        $dumpvars(0,clock, io_input_asyn_reset, io_input_reset, io_input_set, reset, io_output_data);
    end

endmodule
