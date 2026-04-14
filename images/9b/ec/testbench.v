`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] inAddr;
    reg loadAddr;
    reg rst;
    wire [7:0] addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .inAddr(inAddr),
        .loadAddr(loadAddr),
        .rst(rst),
        .addr(addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        loadAddr = 0;
        inAddr = 8'h00;
        @(negedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();


        #1;



        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        repeat(10) @(negedge clk);
        #1;

        #1;


        check_outputs(8'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        inAddr = 8'hA5;
        loadAddr = 1;
        @(negedge clk);
        #1;
        loadAddr = 0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        inAddr = 8'h20;
        loadAddr = 1;
        @(negedge clk);
        loadAddr = 0;
        @(negedge clk);
        #1;
        #1;

        check_outputs(8'h21);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        inAddr = 8'hFF;
        loadAddr = 1;
        @(negedge clk);
        loadAddr = 0;
        @(negedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        inAddr = 8'h55;
        loadAddr = 1;
        rst = 1;
        @(negedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        repeat(255) @(negedge clk);
        #1;
        #1;

        check_outputs(8'hFF);
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
        testcase007();
        
        
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
        input [7:0] expected_addr;
        begin
            if (expected_addr === (expected_addr ^ addr ^ expected_addr)) begin
                $display("PASS");
                $display("  Outputs: addr=%h",
                         addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h",
                         expected_addr);
                $display("  Got:      addr=%h",
                         addr);
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
        $dumpvars(0,clk, inAddr, loadAddr, rst, addr);
    end

endmodule
