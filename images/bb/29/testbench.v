`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg rst;
    reg shen;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rst(rst),
        .shen(shen),
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
        shen = 0;
        din = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Power-on Reset", test_num);
        reset_dut();
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Single Bit Shift", test_num);
        reset_dut();

        @(posedge clk);
        #1 shen = 1; din = 8'h01;
        @(posedge clk);
        #1 shen = 0;

        #1;


        check_outputs(8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Multi-bit Shift Sequence", test_num);
        reset_dut();

        @(posedge clk);
        #1 shen = 1; din = 8'h01;
        @(posedge clk);
        #1 shen = 1; din = 8'h00;
        @(posedge clk);
        #1 shen = 1; din = 8'h01;
        @(posedge clk);
        #1 shen = 1; din = 8'h01;
        @(posedge clk);
        #1 shen = 0;

        #1;


        check_outputs(8'h0B);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Shift Enable De-assertion", test_num);
        reset_dut();

        @(posedge clk);
        #1 shen = 1; din = 8'h01;
        @(posedge clk);
        #1 shen = 1; din = 8'h01;
        @(posedge clk);
        #1 shen = 0; din = 8'h01;
        @(posedge clk);
        @(posedge clk);

        #1;


        check_outputs(8'h03);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        $display("Test Case %0d: Fill Register (8 shifts)", test_num);
        reset_dut();

        for(i=0; i<8; i=i+1) begin
            @(posedge clk);
            #1 shen = 1; din = 8'hFF;
        end
        @(posedge clk);
        #1 shen = 0;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    integer i;
    reg [7:0] pattern;
    begin
        test_num = 6;
        pattern = 8'b10101010;
        $display("Test Case %0d: Pattern Shift (0xAA)", test_num);
        reset_dut();

        for(i=7; i>=0; i=i-1) begin
            @(posedge clk);
            #1 shen = 1; din = {7'b0, pattern[i]};
        end
        @(posedge clk);
        #1 shen = 0;

        #1;


        check_outputs(8'hAA);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Reset Mid-operation", test_num);
        reset_dut();

        @(posedge clk);
        #1 shen = 1; din = 8'hFF;
        @(posedge clk);
        #1 shen = 1; din = 8'hFF;
        @(posedge clk);
        #1 rst = 1;
        @(posedge clk);
        #1 rst = 0;

        #1;


        check_outputs(8'h00);
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
        $dumpvars(0,clk, din, rst, shen, dout);
    end

endmodule
