`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] init_value;
    reg load;
    reg [3:0] max_value;
    reg rst;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .init_value(init_value),
        .load(load),
        .max_value(max_value),
        .rst(rst),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        load = 0;
        init_value = 4'h0;
        max_value = 4'hF;
        #7;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        init_value = 4'h5;
        max_value = 4'hA;
        reset_dut();

        #1;


        check_outputs(4'h5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        init_value = 4'h0;
        max_value = 4'hF;
        reset_dut();
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        init_value = 4'h0;
        max_value = 4'hF;
        reset_dut();


        init_value = 4'hC;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        init_value = 4'h2;
        max_value = 4'h4;
        reset_dut();




        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        init_value = 4'hE;
        max_value = 4'hF;
        reset_dut();

        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        init_value = 4'h8;
        max_value = 4'h9;
        reset_dut();




        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h9);
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
        input [3:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, init_value, load, max_value, rst, count);
    end

endmodule
