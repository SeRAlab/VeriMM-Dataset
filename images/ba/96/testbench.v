`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr;
    reg clk;
    reg [15:0] di;
    reg en;
    reg rst;
    reg we;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .di(di),
        .en(en),
        .rst(rst),
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
        rst = 1;
        en = 0;
        we = 0;
        addr = 0;
        di = 0;
        @(posedge clk);
        #1 rst = 0;

        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase 001: Basic Write and Read (Addr 0)");
        en = 1;
        we = 1;
        addr = 10'h000;
        di = 16'hABCD;
        @(posedge clk);

        we = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase 002: Boundary Address Write and Read (Addr 1023)");
        en = 1;
        we = 1;
        addr = 10'd1023;
        di = 16'h55AA;
        @(posedge clk);

        we = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(16'h55AA);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase 003: Verify Write Enable (we=0 prevents writing)");


        en = 1; we = 1; addr = 10'h010; di = 16'h1111;
        @(posedge clk);


        we = 0; di = 16'hEEEE;
        @(posedge clk);


        @(posedge clk);
        #1 #1;
 check_outputs(16'h1111);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase 004: Verify Module Enable (en=0 prevents writing)");


        en = 1; we = 1; addr = 10'h020; di = 16'h2222;
        @(posedge clk);


        en = 0; we = 1; di = 16'hFFFF;
        @(posedge clk);


        en = 1; we = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(16'h2222);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase 005: Verify Reset clears output");


        en = 1; we = 1; addr = 10'h030; di = 16'h3333;
        @(posedge clk);


        we = 0;
        @(posedge clk);


        rst = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase 006: Multi-address Data Integrity");

        en = 1; we = 1;
        addr = 10'h001; di = 16'h0001; @(posedge clk);
        addr = 10'h002; di = 16'h0002; @(posedge clk);

        we = 0; addr = 10'h001; @(posedge clk);

        addr = 10'h002;
        #1 if (dout !== 16'h0001) $display("Subtest A Fail");
        @(posedge clk);
        #1 #1;
 check_outputs(16'h0002);
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
        input [15:0] expected_dout;
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
        $dumpvars(0,addr, clk, di, en, rst, we, dout);
    end

endmodule
