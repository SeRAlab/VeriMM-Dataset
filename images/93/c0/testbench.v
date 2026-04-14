`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] IO_address;
    reg [15:0] IO_data_in;
    reg IO_write;
    reg clock;
    reg [15:0] processor_input;
    reg processor_uart_rx;
    wire [15:0] IO_data_out;
    wire internal_IRQ;
    wire [15:0] processor_output;
    wire processor_uart_tx;

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
        .processor_uart_rx(processor_uart_rx),
        .IO_data_out(IO_data_out),
        .internal_IRQ(internal_IRQ),
        .processor_output(processor_output),
        .processor_uart_tx(processor_uart_tx)
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
            IO_write = 0;
            processor_input = 16'h0;
            processor_uart_rx = 1'b1;
            repeat(2) @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge clock);
            IO_address = 12'h100;
            IO_data_in = 16'hABCD;
            IO_write = 1;
            @(posedge clock);
            IO_write = 0;


            @(posedge clock);



            #1;




            check_outputs(16'hABCD, 1'b0, 16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Address Isolation", test_num);
            reset_dut();


            @(posedge clock);
            IO_address = 12'h001;
            IO_data_in = 16'h1111;
            IO_write = 1;
            @(posedge clock);


            IO_address = 12'h002;
            IO_data_in = 16'h2222;
            IO_write = 1;
            @(posedge clock);
            IO_write = 0;


            IO_address = 12'h001;
            @(posedge clock);

            #1;


            check_outputs(16'h1111, 1'b0, 16'h0000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Memory Overwrite", test_num);
            reset_dut();


            @(posedge clock);
            IO_address = 12'hAAA;
            IO_data_in = 16'h5555;
            IO_write = 1;
            @(posedge clock);


            IO_data_in = 16'hFFFF;
            @(posedge clock);
            IO_write = 0;


            @(posedge clock);
            #1;

            check_outputs(16'hFFFF, 1'b0, 16'h0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Processor Data Path", test_num);
            reset_dut();

            @(posedge clock);
            processor_input = 16'hA5A5;
            @(posedge clock);



            #1;




            check_outputs(16'h0000, 1'b0, 16'hA5A5, 1'b0);
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
        input [15:0] expected_IO_data_out;
        input expected_internal_IRQ;
        input [15:0] expected_processor_output;
        input expected_processor_uart_tx;
        begin
            if (expected_IO_data_out === (expected_IO_data_out ^ IO_data_out ^ expected_IO_data_out) &&
                expected_internal_IRQ === (expected_internal_IRQ ^ internal_IRQ ^ expected_internal_IRQ) &&
                expected_processor_output === (expected_processor_output ^ processor_output ^ expected_processor_output) &&
                expected_processor_uart_tx === (expected_processor_uart_tx ^ processor_uart_tx ^ expected_processor_uart_tx)) begin
                $display("PASS");
                $display("  Outputs: IO_data_out=%h, internal_IRQ=%b, processor_output=%h, processor_uart_tx=%b",
                         IO_data_out, internal_IRQ, processor_output, processor_uart_tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IO_data_out=%h, internal_IRQ=%b, processor_output=%h, processor_uart_tx=%b",
                         expected_IO_data_out, expected_internal_IRQ, expected_processor_output, expected_processor_uart_tx);
                $display("  Got:      IO_data_out=%h, internal_IRQ=%b, processor_output=%h, processor_uart_tx=%b",
                         IO_data_out, internal_IRQ, processor_output, processor_uart_tx);
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
        $dumpvars(0,IO_address, IO_data_in, IO_write, clock, processor_input, processor_uart_rx, IO_data_out, internal_IRQ, processor_output, processor_uart_tx);
    end

endmodule
