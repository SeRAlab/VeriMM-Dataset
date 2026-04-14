`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] a;
    reg [9:0] b;
    reg ce;
    reg clk;
    reg clr;
    wire op;

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
        .clr(clr),
        .op(op)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        a = 0;
        b = 0;
        ce = 0;
        clr = 1;
        @(posedge clk);
        #1;
        clr = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 10'd512;
        b = 10'd512;
        ce = 1;
        clr = 0;
        @(posedge clk);
        #1;
        $display("Testcase %0d: a=%d, b=%d, ce=%b, clr=%b", test_num, a, b, ce, clr);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 10'd512;
        b = 10'd128;
        ce = 1;
        clr = 0;
        @(posedge clk);
        #1;
        $display("Testcase %0d: a=%d, b=%d, ce=%b, clr=%b", test_num, a, b, ce, clr);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();

        a = 10'd100;
        b = 10'd100;
        ce = 1;
        clr = 0;
        @(posedge clk);
        #1;

        b = 10'd200;
        ce = 0;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Hold state - a=%d, b=%d, ce=%b", test_num, a, b, ce);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();

        a = 10'd777;
        b = 10'd777;
        ce = 1;
        clr = 1;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Clear active with a==b - a=%d, b=%d, clr=%b", test_num, a, b, clr);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 10'h3FF;
        b = 10'h3FF;
        ce = 1;
        clr = 0;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Boundary Max Values - a=%h, b=%h", test_num, a, b);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();

        a = 10'd10;
        b = 10'd10;
        ce = 1;
        @(posedge clk);
        #1;

        a = 10'd10;
        b = 10'd11;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Transition Equal -> Not Equal - a=%d, b=%d", test_num, a, b);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 10'd5;
        b = 10'd5;
        ce = 1;
        @(posedge clk);
        #1;

        clr = 1;
        @(posedge clk);
        #1;

        clr = 0;
        a = 10'd5;
        b = 10'd6;
        ce = 1;
        @(posedge clk);
        #1;

        a = 10'd6;
        @(posedge clk);
        #1;

        $display("Testcase %0d: Sequential toggle logic check", test_num);
        #1;

        check_outputs(1'b1);
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
        input expected_op;
        begin
            if (expected_op === (expected_op ^ op ^ expected_op)) begin
                $display("PASS");
                $display("  Outputs: op=%b",
                         op);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: op=%b",
                         expected_op);
                $display("  Got:      op=%b",
                         op);
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
        $dumpvars(0,a, b, ce, clk, clr, op);
    end

endmodule
