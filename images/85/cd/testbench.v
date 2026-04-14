`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
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
            $display("Running testcase001: Basic Equality Check (a == b, ce = 1)");
            reset_dut();
            a = 8'hA5;
            b = 8'hA5;
            ce = 1;
            clr = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Inequality Check (a != b, ce = 1)");
            reset_dut();
            a = 8'hA5;
            b = 8'h5A;
            ce = 1;
            clr = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Clear Signal Priority (a == b, ce = 1, clr = 1)");
            reset_dut();
            a = 8'hFF;
            b = 8'hFF;
            ce = 1;
            clr = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: ce Low maintains previous HIGH state");
            reset_dut();

            a = 8'h12;
            b = 8'h12;
            ce = 1;
            clr = 0;
            @(posedge clk);

            ce = 0;
            a = 8'hFF;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: ce Low maintains previous LOW state");
            reset_dut();

            a = 8'h12;
            b = 8'h34;
            ce = 1;
            clr = 0;
            @(posedge clk);

            ce = 0;
            b = 8'h12;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: All zeros comparison");
            reset_dut();
            a = 8'h00;
            b = 8'h00;
            ce = 1;
            clr = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: All ones comparison");
            reset_dut();
            a = 8'hFF;
            b = 8'hFF;
            ce = 1;
            clr = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Single bit difference check");
            reset_dut();
            a = 8'b10101010;
            b = 8'b10101011;
            ce = 1;
            clr = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Running testcase009: Inputs ignored while clr is active");
            reset_dut();
            a = 8'hAA;
            b = 8'hAA;
            ce = 1;
            clr = 1;
            @(posedge clk);
            a = 8'hBB;
            b = 8'hBB;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            $display("Running testcase010: Transition from clr to normal operation");
            reset_dut();

            a = 8'hEE; b = 8'hEE; ce = 1; clr = 1;
            @(posedge clk);

            clr = 0;
            @(posedge clk);
            #1 #1;
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
