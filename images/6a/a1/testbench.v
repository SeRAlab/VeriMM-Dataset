`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] a1;
    reg [4:0] a2;
    reg [4:0] a3;
    reg clk;
    reg [31:0] wdata;
    reg wr;
    reg [4:0] wreg;
    wire [31:0] d1;
    wire [31:0] d2;
    wire [31:0] d3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .clk(clk),
        .wdata(wdata),
        .wr(wr),
        .wreg(wreg),
        .d1(d1),
        .d2(d2),
        .d3(d3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a1 = 0;
            a2 = 0;
            a3 = 0;
            wdata = 0;
            wr = 0;
            wreg = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read (Reg 1)", test_num);


            wr = 1;
            wreg = 5'd1;
            wdata = 32'hAAAABBBB;
            @(posedge clk);
            #1;


            wr = 0;
            a1 = 5'd1;
            a2 = 5'd1;
            a3 = 5'd1;
            #2;

            #1;


            check_outputs(32'hAAAABBBB, 32'hAAAABBBB, 32'hAAAABBBB);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Register 0 Constant Low", test_num);


            wr = 1;
            wreg = 5'd0;
            wdata = 32'hFFFFFFFF;
            @(posedge clk);
            #1;


            wr = 0;
            a1 = 5'd0;
            a2 = 5'd0;
            a3 = 5'd0;
            #2;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Write Bypass Logic", test_num);


            wr = 1;
            wreg = 5'd10;
            wdata = 32'h12345678;
            a1 = 5'd10;
            a2 = 5'd10;
            a3 = 5'd10;


            #2;
            #1;

            check_outputs(32'h12345678, 32'h12345678, 32'h12345678);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Write Enable Control", test_num);


            wr = 0;
            wreg = 5'd15;
            wdata = 32'hCAFEFACE;
            @(posedge clk);
            #1;


            a1 = 5'd15;
            #2;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Independent Port Reads", test_num);


            wr = 1; wreg = 5'd2; wdata = 32'h11111111; @(posedge clk); #1;

            wr = 1; wreg = 5'd3; wdata = 32'h22222222; @(posedge clk); #1;

            wr = 1; wreg = 5'd4; wdata = 32'h33333333; @(posedge clk); #1;


            wr = 0;
            a1 = 5'd2;
            a2 = 5'd3;
            a3 = 5'd4;
            #2;

            #1;


            check_outputs(32'h11111111, 32'h22222222, 32'h33333333);
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
        input [31:0] expected_d1;
        input [31:0] expected_d2;
        input [31:0] expected_d3;
        begin
            if (expected_d1 === (expected_d1 ^ d1 ^ expected_d1) &&
                expected_d2 === (expected_d2 ^ d2 ^ expected_d2) &&
                expected_d3 === (expected_d3 ^ d3 ^ expected_d3)) begin
                $display("PASS");
                $display("  Outputs: d1=%h, d2=%h, d3=%h",
                         d1, d2, d3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d1=%h, d2=%h, d3=%h",
                         expected_d1, expected_d2, expected_d3);
                $display("  Got:      d1=%h, d2=%h, d3=%h",
                         d1, d2, d3);
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
        $dumpvars(0,a1, a2, a3, clk, wdata, wr, wreg, d1, d2, d3);
    end

endmodule
