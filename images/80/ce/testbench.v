`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] d;
    reg en;
    reg resetn;
    reg squashn;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .en(en),
        .resetn(resetn),
        .squashn(squashn),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        resetn = 0;
        en = 0;
        squashn = 1;
        d = 0;
        @(posedge clk);
        #1;
        resetn = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Synchronous Reset", test_num);
        reset_dut();
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Data Write (en=1)", test_num);
        reset_dut();
        d = 32'hA5A5A5A5;
        en = 1;
        squashn = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Enable Logic (Hold state when en=0)", test_num);
        reset_dut();

        d = 32'h12345678;
        en = 1;
        @(posedge clk);
        #1;

        d = 32'hFFFFFFFF;
        en = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Squash Immediate Effect", test_num);
        reset_dut();
        d = 32'hDEADBEEF;
        en = 1;
        squashn = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Squash Save Mechanism (Previous State)", test_num);
        reset_dut();

        d = 32'h11111111;
        en = 1;
        squashn = 0;
        @(posedge clk);
        #1;

        squashn = 1;
        d = 32'h22222222;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset Priority", test_num);
        reset_dut();
        d = 32'h88887777;
        en = 1;
        resetn = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Recovery after Squash", test_num);
        reset_dut();

        squashn = 0; @(posedge clk); #1;

        squashn = 1; @(posedge clk); #1;

        d = 32'hCAFEFACE;
        en = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hCAFEFACE);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Maximum Value Load", test_num);
        reset_dut();
        d = 32'hFFFFFFFF;
        en = 1;
        squashn = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hFFFFFFFF);
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
        $dumpvars(0,clk, d, en, resetn, squashn, q);
    end

endmodule
