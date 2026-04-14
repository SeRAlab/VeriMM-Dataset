`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [31:0] WD;
    reg WE;
    reg clk;
    wire [31:0] RD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .WD(WD),
        .WE(WE),
        .clk(clk),
        .RD(RD)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        A = 32'b0;
        WD = 32'b0;
        WE = 1'b0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Write/Read", test_num);
        reset_dut();


        A = 32'h4;
        WD = 32'hAAAA_BBBB;
        WE = 1'b1;
        @(posedge clk);
        #1;


        WE = 1'b0;
        #2;
        #1;

        check_outputs(32'hAAAA_BBBB);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary Address Write/Read", test_num);
        reset_dut();


        A = 32'd124;
        WD = 32'h5555_6666;
        WE = 1'b1;
        @(posedge clk);
        #1;

        WE = 1'b0;
        #2;
        #1;

        check_outputs(32'h5555_6666);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Head Location Special Logic (WE=0)", test_num);
        reset_dut();


        A = 32'h0;
        WD = 32'hFFFF_FFFF;
        WE = 1'b1;
        @(posedge clk);
        #1;


        WE = 1'b0;
        #2;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Write Enable (WE=0) Verification", test_num);
        reset_dut();


        A = 32'd20;
        WD = 32'h1111_2222;
        WE = 1'b1;
        @(posedge clk);
        #1;


        WD = 32'hDEAD_BEEF;
        WE = 1'b0;
        @(posedge clk);
        #1;


        #2;
        #1;

        check_outputs(32'h1111_2222);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sequential Read Verification", test_num);
        reset_dut();


        A = 32'd40;
        WD = 32'h8888_9999;
        WE = 1'b1;
        @(posedge clk);
        #1;


        A = 32'd44;
        WD = 32'hCCCC_DDDD;
        WE = 1'b1;
        @(posedge clk);
        #1;


        WE = 1'b0;
        A = 32'd40;
        #2;
        #1;

        check_outputs(32'h8888_9999);
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
        input [31:0] expected_RD;
        begin
            if (expected_RD === (expected_RD ^ RD ^ expected_RD)) begin
                $display("PASS");
                $display("  Outputs: RD=%h",
                         RD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RD=%h",
                         expected_RD);
                $display("  Got:      RD=%h",
                         RD);
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
        $dumpvars(0,A, WD, WE, clk, RD);
    end

endmodule
