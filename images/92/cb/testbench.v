`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg [3:0] in_a;
    reg [3:0] in_b;
    reg sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .in_a(in_a),
        .in_b(in_b),
        .sel(sel),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            sel = 0;
            in_a = 4'h0;
            in_b = 4'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            en = 1;
            sel = 0;
            in_a = 4'hA;
            in_b = 4'h5;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Select in_a (sel=0, en=1)", test_num);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            en = 1;
            sel = 1;
            in_a = 4'hA;
            in_b = 4'h5;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Select in_b (sel=1, en=1)", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            en = 1;
            sel = 0;
            in_a = 4'h7;
            @(posedge clk);
            #1;

            en = 0;
            sel = 1;
            in_a = 4'hF;
            in_b = 4'hF;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Hold value (en=0)", test_num);
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            en = 1;
            sel = 0;
            in_a = 4'hF;
            in_b = 4'h0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Select in_a (4'hF)", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            en = 1;

            sel = 0; in_a = 4'h1; in_b = 4'h2;
            @(posedge clk);
            #1;

            sel = 1; in_a = 4'h1; in_b = 4'h2;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Sequential selection switch", test_num);
            #1;

            check_outputs(4'h2);
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
        input [3:0] expected_out;
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
        $dumpvars(0,clk, en, in_a, in_b, sel, out);
    end

endmodule
