`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] addr;
    reg clk;
    reg [7:0] din;
    reg we;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .we(we),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        addr = 0;
        din = 0;
        we = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Simple Write and Read...");
        reset_dut();
        addr = 7'h05;
        din = 8'hAA;
        we = 1;
        @(posedge clk);
        #2;
        we = 0;
        addr = 7'h05;
        #5;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Boundary Address (0x7F)...");
        reset_dut();
        addr = 7'h7F;
        din = 8'h55;
        we = 1;
        @(posedge clk);
        #2;
        we = 0;
        #5;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Overwriting data...");
        reset_dut();

        addr = 7'h10;
        din = 8'h12;
        we = 1;
        @(posedge clk);
        #5;

        din = 8'h34;
        @(posedge clk);
        #2;
        we = 0;
        #5;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Write Enable check...");
        reset_dut();

        addr = 7'h20;
        din = 8'hBE;
        we = 1;
        @(posedge clk);
        #5;

        din = 8'hEF;
        we = 0;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'hBE);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Continuous read check...");
        reset_dut();

        addr = 7'h30;
        din = 8'hCC;
        we = 1;
        @(posedge clk);
        #5;

        addr = 7'h31;
        din = 8'hDD;
        @(posedge clk);
        #2;
        we = 0;

        addr = 7'h30;
        #5;
        #1;

        check_outputs(8'hCC);
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
        input [7:0] expected_dout;
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
        $dumpvars(0,addr, clk, din, we, dout);
    end

endmodule
