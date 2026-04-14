`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] adc_data;
    reg clk;
    reg [9:0] mem_addr;
    reg [7:0] mem_data;
    reg mem_read;
    reg mem_write;
    reg rst;
    reg start;
    wire [7:0] mem_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adc_data(adc_data),
        .clk(clk),
        .mem_addr(mem_addr),
        .mem_data(mem_data),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .rst(rst),
        .start(start),
        .mem_out(mem_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            mem_read = 0;
            mem_write = 0;
            adc_data = 8'h00;
            mem_addr = 10'h000;
            mem_data = 8'h00;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Manual Memory Write and Read", test_num);
            reset_dut();


            mem_addr = 10'h010;
            mem_data = 8'hAA;
            mem_write = 1;
            @(posedge clk);
            #1 mem_write = 0;


            mem_read = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
            mem_read = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ADC Capture (DAQ Flow)", test_num);
            reset_dut();


            adc_data = 8'h55;
            mem_addr = 10'h020;


            start = 1;
            @(posedge clk);
            #1 start = 0;


            repeat(4) @(posedge clk);


            mem_read = 1;
            mem_addr = 10'h020;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
            mem_read = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address Access (0x3FF)", test_num);
            reset_dut();

            mem_addr = 10'h3FF;
            mem_data = 8'hC3;
            mem_write = 1;
            @(posedge clk);
            #1 mem_write = 0;

            mem_read = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hC3);
            mem_read = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Memory Overwrite", test_num);
            reset_dut();


            mem_addr = 10'h005;
            mem_data = 8'h11;
            mem_write = 1;
            @(posedge clk);
            #1;


            mem_data = 8'h22;
            @(posedge clk);
            #1 mem_write = 0;

            mem_read = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22);
            mem_read = 0;
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
        input [7:0] expected_mem_out;
        begin
            if (expected_mem_out === (expected_mem_out ^ mem_out ^ expected_mem_out)) begin
                $display("PASS");
                $display("  Outputs: mem_out=%h",
                         mem_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_out=%h",
                         expected_mem_out);
                $display("  Got:      mem_out=%h",
                         mem_out);
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
        $dumpvars(0,adc_data, clk, mem_addr, mem_data, mem_read, mem_write, rst, start, mem_out);
    end

endmodule
