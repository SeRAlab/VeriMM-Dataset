`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] F_in;
    reg clk;
    reg reset;
    reg wEnable;
    wire [4:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .F_in(F_in),
        .clk(clk),
        .reset(reset),
        .wEnable(wEnable),
        .r(r)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        reset = 1;
        wEnable = 0;
        F_in = 5'b0;
        @(negedge clk);
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify Reset", test_num);
        reset_dut();


        #1;



        check_outputs(5'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write (0x1A)", test_num);
        reset_dut();
        @(negedge clk);
        wEnable = 1;
        F_in = 5'h1A;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'h1A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data Retention (wEnable=0)", test_num);
        reset_dut();

        @(negedge clk);
        wEnable = 1;
        F_in = 5'h0F;
        @(posedge clk);

        @(negedge clk);
        wEnable = 0;
        F_in = 5'h15;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'h0F);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Priority", test_num);
        reset_dut();
        @(negedge clk);
        reset = 1;
        wEnable = 1;
        F_in = 5'h1F;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Value Write (0x1F)", test_num);
        reset_dut();
        @(negedge clk);
        wEnable = 1;
        F_in = 5'h1F;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Consecutive Writes", test_num);
        reset_dut();
        @(negedge clk);
        wEnable = 1;
        F_in = 5'h05;
        @(posedge clk);
        @(negedge clk);
        F_in = 5'h12;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'h12);
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
        input [4:0] expected_r;
        begin
            if (expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: r=%h",
                         r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%h",
                         expected_r);
                $display("  Got:      r=%h",
                         r);
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
        $dumpvars(0,F_in, clk, reset, wEnable, r);
    end

endmodule
