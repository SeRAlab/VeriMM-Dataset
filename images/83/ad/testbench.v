`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr;
    reg ce;
    reg clk;
    reg [31:0] din;
    reg rstn;
    reg we;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .ce(ce),
        .clk(clk),
        .din(din),
        .rstn(rstn),
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
        rstn = 0;
        ce = 0;
        we = 0;
        addr = 0;
        din = 0;
        @(posedge clk);
        #1 rstn = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Write and Read back", test_num);


        @(posedge clk);
        ce = 1;
        we = 1;
        addr = 10'h0A5;
        din = 32'hDEADBEEF;


        @(posedge clk);
        we = 0;
        addr = 10'h0A5;


        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Sequential Write and check second address", test_num);


        @(posedge clk);
        ce = 1; we = 1; addr = 10'h001; din = 32'h11111111;


        @(posedge clk);
        addr = 10'h002; din = 32'h22222222;


        @(posedge clk);
        we = 0; addr = 10'h002;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h22222222);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Chip Enable (CE) Inactive Protection", test_num);


        @(posedge clk);
        ce = 1; we = 1; addr = 10'h050; din = 32'hAAAA5555;


        @(posedge clk);
        ce = 0; we = 1; addr = 10'h050; din = 32'hFFFFFFFF;


        @(posedge clk);
        ce = 1; we = 0; addr = 10'h050;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hAAAA5555);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Overwriting an existing memory location", test_num);


        @(posedge clk);
        ce = 1; we = 1; addr = 10'h100; din = 32'h12345678;


        @(posedge clk);
        din = 32'h87654321;


        @(posedge clk);
        we = 0;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h87654321);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary Address Check (Address 1023)", test_num);

        @(posedge clk);
        ce = 1; we = 1; addr = 10'h3FF; din = 32'hCAFEFEED;

        @(posedge clk);
        we = 0;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hCAFEFEED);
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
        input [31:0] expected_dout;
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
        $dumpvars(0,addr, ce, clk, din, rstn, we, dout);
    end

endmodule
