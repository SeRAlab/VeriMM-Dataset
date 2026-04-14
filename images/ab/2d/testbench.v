`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [7:0] di;
    reg rst;
    wire [7:0] doq;
    wire tag_v;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .di(di),
        .rst(rst),
        .doq(doq),
        .tag_v(tag_v)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            addr = 0;
            di = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();

        #1;


        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();


        addr = 8'h10;
        di = 8'hAA;
        @(posedge clk);
        #1;


        addr = 8'h10;
        @(posedge clk);
        #1;


        #1;



        check_outputs(8'hAA, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();


        addr = 8'h20; di = 8'h55;
        @(posedge clk);
        #1;


        addr = 8'h30; di = 8'h66;
        @(posedge clk);
        #1;


        addr = 8'h20;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h55, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();


        addr = 8'h30; di = 8'h66;
        @(posedge clk);
        #1;


        addr = 8'h30;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h66, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();


        addr = 8'h40; di = 8'hFF;
        @(posedge clk);
        #1;


        reset_dut();



        addr = 8'h40; di = 8'hEE;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h00, 1'b0);
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
        input [7:0] expected_doq;
        input expected_tag_v;
        begin
            if (expected_doq === (expected_doq ^ doq ^ expected_doq) &&
                expected_tag_v === (expected_tag_v ^ tag_v ^ expected_tag_v)) begin
                $display("PASS");
                $display("  Outputs: doq=%h, tag_v=%b",
                         doq, tag_v);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: doq=%h, tag_v=%b",
                         expected_doq, expected_tag_v);
                $display("  Got:      doq=%h, tag_v=%b",
                         doq, tag_v);
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
        $dumpvars(0,addr, clk, di, rst, doq, tag_v);
    end

endmodule
