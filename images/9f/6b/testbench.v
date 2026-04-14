`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] addr;
    reg clk;
    reg [1:0] din;
    reg we;
    wire [1:0] dout;

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
        $display("Testcase %0d: Basic Write and Read", test_num);
        reset_dut();


        @(posedge clk);
        we = 1;
        addr = 14'h000A;
        din = 2'b11;


        @(posedge clk);
        we = 0;
        addr = 14'h000A;


        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write Enable (we) Check", test_num);
        reset_dut();


        @(posedge clk);
        we = 0;
        addr = 14'h0100;
        din = 2'b01;


        @(posedge clk);
        addr = 14'h0100;


        @(posedge clk);
        #1;

        #1;


        check_outputs(2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max Address Range Check", test_num);
        reset_dut();


        @(posedge clk);
        we = 1;
        addr = 14'h3FFF;
        din = 2'b10;

        @(posedge clk);
        we = 0;
        addr = 14'h3FFF;

        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Successive writes to different addresses", test_num);
        reset_dut();


        @(posedge clk);
        we = 1; addr = 14'h0001; din = 2'b01;

        @(posedge clk);
        we = 1; addr = 14'h0002; din = 2'b11;


        @(posedge clk);
        we = 0; addr = 14'h0001;

        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overwriting data", test_num);
        reset_dut();


        @(posedge clk);
        we = 1; addr = 14'h0555; din = 2'b11;

        @(posedge clk);
        we = 1; addr = 14'h0555; din = 2'b10;


        @(posedge clk);
        we = 0; addr = 14'h0555;

        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b10);
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
        input [1:0] expected_dout;
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
