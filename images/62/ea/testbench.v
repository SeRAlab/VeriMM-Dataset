`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr;
    reg clk;
    wire [799:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        addr <= 10'd0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: Reading Address 0x000", test_num);
        addr <= 10'h000;
        @(posedge clk);
        #1;

        #1;


        check_outputs(800'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: Reading Address 0x3FF (Boundary Check)", test_num);
        addr <= 10'h3FF;
        @(posedge clk);
        #1;

        #1;


        check_outputs(800'h3FF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: Reading Address 0x200 (Mid-range Check)", test_num);
        addr <= 10'h200;
        @(posedge clk);
        #1;
        #1;

        check_outputs(800'h200);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: Reading Address 0x155 (Pattern Check)", test_num);
        addr <= 10'h155;
        @(posedge clk);
        #1;
        #1;

        check_outputs(800'h155);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: Reading Address 0x0AA", test_num);
        addr <= 10'h0AA;
        @(posedge clk);
        #1;
        #1;

        check_outputs(800'h0AA);
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
        input [799:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,addr, clk, dout);
    end

endmodule
