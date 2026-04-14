`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] IO_address;
    reg [15:0] IO_data_in;
    reg IO_write;
    reg clock;
    reg [15:0] processor_input;
    wire [15:0] IO_data_out;
    wire [15:0] processor_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IO_address(IO_address),
        .IO_data_in(IO_data_in),
        .IO_write(IO_write),
        .clock(clock),
        .processor_input(processor_input),
        .IO_data_out(IO_data_out),
        .processor_output(processor_output)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            IO_address = 12'h0;
            IO_data_in = 16'h0;
            IO_write = 1'b0;
            processor_input = 16'h0;
            repeat(2) @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            IO_address = 12'h000;
            IO_data_in = 16'hABCD;
            IO_write = 1'b1;
            processor_input = 16'h0000;
            @(posedge clock);
            #1;

            IO_write = 1'b0;
            @(posedge clock);
            #1;

            $display("Testcase %0d: Basic Write/Read at 0x000", test_num);
            #1;

            check_outputs(16'hABCD, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();

            IO_address = 12'hFFF;
            IO_data_in = 16'h55AA;
            IO_write = 1'b1;
            processor_input = 16'h1234;
            @(posedge clock);
            #1;

            IO_write = 1'b0;
            @(posedge clock);
            #1;

            $display("Testcase %0d: Boundary Test at 0xFFF", test_num);
            #1;

            check_outputs(16'h55AA, 16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            IO_address = 12'h123;
            IO_data_in = 16'h9999;
            IO_write = 1'b1;
            @(posedge clock);
            #1;

            IO_write = 1'b0;
            processor_input = 16'hDEAD;
            @(posedge clock);
            #1;

            $display("Testcase %0d: Processor passthrough check", test_num);
            #1;

            check_outputs(16'h9999, 16'hDEAD);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            IO_address = 12'hA00;
            IO_data_in = 16'h1111;
            IO_write = 1'b1;
            @(posedge clock);
            #1;

            IO_data_in = 16'h2222;
            @(posedge clock);
            #1;

            IO_write = 1'b0;
            @(posedge clock);
            #1;
            $display("Testcase %0d: Memory Overwrite check", test_num);
            #1;

            check_outputs(16'h2222, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            IO_address = 12'h001; IO_data_in = 16'hE001; IO_write = 1'b1;
            @(posedge clock); #1;

            IO_address = 12'h002; IO_data_in = 16'hE002;
            @(posedge clock); #1;

            IO_write = 1'b0; IO_address = 12'h001;
            processor_input = 16'h8888;
            @(posedge clock); #1;
            $display("Testcase %0d: Multi-address sequential check", test_num);
            #1;

            check_outputs(16'hE001, 16'h8888);
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
        input [15:0] expected_IO_data_out;
        input [15:0] expected_processor_output;
        begin
            if (expected_IO_data_out === (expected_IO_data_out ^ IO_data_out ^ expected_IO_data_out) &&
                expected_processor_output === (expected_processor_output ^ processor_output ^ expected_processor_output)) begin
                $display("PASS");
                $display("  Outputs: IO_data_out=%h, processor_output=%h",
                         IO_data_out, processor_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IO_data_out=%h, processor_output=%h",
                         expected_IO_data_out, expected_processor_output);
                $display("  Got:      IO_data_out=%h, processor_output=%h",
                         IO_data_out, processor_output);
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
        $dumpvars(0,IO_address, IO_data_in, IO_write, clock, processor_input, IO_data_out, processor_output);
    end

endmodule
