`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cl;
    reg clk;
    reg [31:0] d;
    reg up;
    reg w;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cl(cl),
        .clk(clk),
        .d(d),
        .up(up),
        .w(w),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        cl = 1;
        w = 0;
        up = 0;
        d = 0;
        @(posedge clk);
        #1;
        cl = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Synchronous Clear", test_num);
        reset_dut();

        #1;


        check_outputs(32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Load Data", test_num);
        reset_dut();
        d = 32'hDEADBEEF;
        w = 1;
        @(posedge clk);
        #1;
        w = 0;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Basic Increment", test_num);
        reset_dut();
        up = 1;
        @(posedge clk);
        #1;
        up = 0;
        #1;

        check_outputs(32'h1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Multiple Increments", test_num);
        reset_dut();
        up = 1;
        repeat(10) @(posedge clk);
        #1;
        up = 0;
        #1;

        check_outputs(32'd10);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Priority (Clear > Write)", test_num);
        reset_dut();
        cl = 1;
        w = 1;
        d = 32'h12345678;
        @(posedge clk);
        #1;
        cl = 0;
        w = 0;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Priority (Write > Up)", test_num);
        reset_dut();
        w = 1;
        up = 1;
        d = 32'hABCDEF01;
        @(posedge clk);
        #1;
        w = 0;
        up = 0;
        #1;

        check_outputs(32'hABCDEF01);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Hold Value", test_num);
        reset_dut();

        w = 1; d = 32'h55; @(posedge clk); #1;
        w = 0; up = 0; cl = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(32'h55);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Counter Roll-over", test_num);
        reset_dut();

        w = 1; d = 32'hFFFFFFFF; @(posedge clk); #1;
        w = 0; up = 1;
        @(posedge clk);
        #1;
        up = 0;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %03d: Resume Count after Load", test_num);
        reset_dut();
        w = 1; d = 32'h000000FE; @(posedge clk); #1;
        w = 0; up = 1;
        @(posedge clk);
        @(posedge clk);
        #1;
        up = 0;
        #1;

        check_outputs(32'h00000100);
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
        input [31:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,cl, clk, d, up, w, q);
    end

endmodule
