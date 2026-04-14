`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg ce;
    reg clk;
    reg reset;
    wire [31:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ce(ce),
        .clk(clk),
        .reset(reset),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        ce = 0;
        a = 0;
        b = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive * Positive (12 * 5)", test_num);
        reset_dut();
        a = 32'sd12;
        b = 32'sd5;
        ce = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(32'sd60);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative * Positive (-15 * 4)", test_num);
        reset_dut();
        a = -32'sd15;
        b = 32'sd4;
        ce = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(-32'sd60);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive * Negative (10 * -8)", test_num);
        reset_dut();
        a = 32'sd10;
        b = -32'sd8;
        ce = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(-32'sd80);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative * Negative (-6 * -7)", test_num);
        reset_dut();
        a = -32'sd6;
        b = -32'sd7;
        ce = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(32'sd42);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplication by Zero (0 * -12345)", test_num);
        reset_dut();
        a = 32'sd0;
        b = -32'sd12345;
        ce = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(32'sd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplication by One (1 * -99)", test_num);
        reset_dut();
        a = 32'sd1;
        b = -32'sd99;
        ce = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(-32'sd99);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Clock Enable (CE) low check", test_num);
        reset_dut();


        a = 32'sd10; b = 32'sd10; ce = 1;
        @(posedge clk);
        #1;


        a = 32'sd5; b = 32'sd5; ce = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'sd100);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large Signed Values (check lower 32 bits)", test_num);
        reset_dut();

        a = 32'h0001_0000;
        b = 32'h0001_0000;
        ce = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(32'h0000_0000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Synchronous Reset check", test_num);
        reset_dut();

        a = 32'sd50; b = 32'sd2; ce = 1;
        @(posedge clk);
        #1;

        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Min/Max Signed Multiplication", test_num);
        reset_dut();

        a = 32'h7FFF_FFFF;
        b = 32'sd2;
        ce = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'hFFFF_FFFE);
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
        input [31:0] expected_p;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
        $dumpvars(0,a, b, ce, clk, reset, p);
    end

endmodule
