`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] addr;
    reg clk;
    reg [7:0] din;
    reg en;
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
        .en(en),
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
        en = 0;
        we = 0;
        addr = 0;
        din = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Write and Read at address 0x001", test_num);
        reset_dut();


        @(posedge clk);
        en = 1; we = 1; addr = 12'h001; din = 8'hA5;


        @(posedge clk);
        en = 1; we = 0; addr = 12'h001;


        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Write and Read at boundary address 0xFFF", test_num);
        reset_dut();


        @(posedge clk);
        en = 1; we = 1; addr = 12'hFFF; din = 8'h5A;


        @(posedge clk);
        en = 1; we = 0; addr = 12'hFFF;


        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verify write is disabled when en=0", test_num);
        reset_dut();


        @(posedge clk);
        en = 1; we = 1; addr = 12'h010; din = 8'h11;


        @(posedge clk);
        en = 0; we = 1; addr = 12'h010; din = 8'hEE;


        @(posedge clk);
        en = 1; we = 0; addr = 12'h010;

        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verify write is disabled when we=0", test_num);
        reset_dut();


        @(posedge clk);
        en = 1; we = 1; addr = 12'h020; din = 8'h22;


        @(posedge clk);
        en = 1; we = 0; addr = 12'h020; din = 8'hFF;


        @(posedge clk);
        en = 1; we = 0; addr = 12'h020;

        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multiple address persistence check", test_num);
        reset_dut();


        @(posedge clk);
        en = 1; we = 1; addr = 12'h100; din = 8'hAA;


        @(posedge clk);
        en = 1; we = 1; addr = 12'h200; din = 8'hBB;


        @(posedge clk);
        en = 1; we = 0; addr = 12'h100;

        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Overwriting data at the same address", test_num);
        reset_dut();


        @(posedge clk);
        en = 1; we = 1; addr = 12'hABC; din = 8'h33;


        @(posedge clk);
        en = 1; we = 1; addr = 12'hABC; din = 8'hCC;


        @(posedge clk);
        en = 1; we = 0; addr = 12'hABC;

        @(posedge clk);
        #1;
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
        $dumpvars(0,addr, clk, din, en, we, dout);
    end

endmodule
