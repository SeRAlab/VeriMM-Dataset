`timescale 1ns/1ps

module Decoder3to8_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [2:0] in;
    reg rst_n;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Decoder3to8 dut (
        .clk(clk),
        .enable(enable),
        .in(in),
        .rst_n(rst_n),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        enable = 0;
        in = 3'b000;
        @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Enable=0, In=000", test_num);
        enable = 0;
        in = 3'b000;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Enable=0, In=111", test_num);
        enable = 0;
        in = 3'b111;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Enable=1, In=000", test_num);
        enable = 1;
        in = 3'b000;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h01);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Enable=1, In=001", test_num);
        enable = 1;
        in = 3'b001;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h02);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Enable=1, In=010", test_num);
        enable = 1;
        in = 3'b010;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h04);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Enable=1, In=011", test_num);
        enable = 1;
        in = 3'b011;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h08);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Testcase %0d: Enable=1, In=100", test_num);
        enable = 1;
        in = 3'b100;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h10);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        $display("Testcase %0d: Enable=1, In=101", test_num);
        enable = 1;
        in = 3'b101;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h20);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = 9;
        $display("Testcase %0d: Enable=1, In=110", test_num);
        enable = 1;
        in = 3'b110;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h40);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        test_num = 10;
        $display("Testcase %0d: Enable=1, In=111", test_num);
        enable = 1;
        in = 3'b111;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h80);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Decoder3to8 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, enable, in, rst_n, out);
    end

endmodule
