`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg rst;
    reg [31:0] seed;
    wire [31:0] rand_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .rst(rst),
        .seed(seed),
        .rand_num(rand_num)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        load = 0;
        seed = 0;
        rst = 1;
        #2;
        rst = 0;
        #10;
        rst = 1;
        #10;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verify Reset to Zero", test_num);
        reset_dut();
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verify Load Seed 0xACE1BEEF", test_num);
        reset_dut();
        @(negedge clk);
        seed = 32'hACE1BEEF;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        #1;

        check_outputs(32'hACE1BEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verify Load Seed 0x12345678", test_num);
        reset_dut();
        @(negedge clk);
        seed = 32'h12345678;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verify Load Priority (Hold Value)", test_num);
        reset_dut();
        @(negedge clk);
        seed = 32'hDEADBEEF;
        load = 1;
        repeat (5) @(posedge clk);
        #2;
        #1;

        check_outputs(32'hDEADBEEF);
        load = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verify Reset Priority over Load", test_num);
        reset_dut();
        @(negedge clk);
        seed = 32'hFFFFFFFF;
        load = 1;
        @(posedge clk);
        #2;
        rst = 0;
        #10;
        rst = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h00000000);
        load = 0;
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
        input [31:0] expected_rand_num;
        begin
            if (expected_rand_num === (expected_rand_num ^ rand_num ^ expected_rand_num)) begin
                $display("PASS");
                $display("  Outputs: rand_num=%h",
                         rand_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rand_num=%h",
                         expected_rand_num);
                $display("  Got:      rand_num=%h",
                         rand_num);
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
        $dumpvars(0,clk, load, rst, seed, rand_num);
    end

endmodule
