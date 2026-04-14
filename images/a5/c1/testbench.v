`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg [7:0] data_in;
    reg rst_in;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .data_in(data_in),
        .rst_in(rst_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

    begin
        rst_in = 1;
        data_in = 8'h00;
        @(posedge clk_in);
        #1;
        rst_in = 0;
        @(posedge clk_in);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic synchronization (0xAA)", test_num);
        reset_dut();

        data_in = 8'hAA;


        @(posedge clk_in);
        @(posedge clk_in);
        @(posedge clk_in);
        #1;

        #1;


        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Synchronizing all bits high (0xFF)", test_num);
        reset_dut();

        data_in = 8'hFF;


        repeat(3) @(posedge clk_in);
        #1;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Sequential data update (0x55 -> 0x33)", test_num);
        reset_dut();

        data_in = 8'h55;
        repeat(3) @(posedge clk_in);

        data_in = 8'h33;
        repeat(3) @(posedge clk_in);
        #1;

        #1;


        check_outputs(8'h33);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset impact during data transfer", test_num);
        reset_dut();

        data_in = 8'hCC;
        repeat(3) @(posedge clk_in);


        rst_in = 1;
        @(posedge clk_in);
        #1;


        #1;



        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Alternating bit pattern (0xA5)", test_num);
        reset_dut();

        data_in = 8'hA5;


        @(posedge clk_in);
        @(posedge clk_in);
        #2;

        #1;


        check_outputs(8'hA5);
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk_in, data_in, rst_in, data_out);
    end

endmodule
