`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1023:0] in;
    reg reset;
    reg [7:0] sel;
    wire [15:0] Q;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .sel(sel),
        .Q(Q),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 0;
            sel = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking Synchronous Reset", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: MUX Index 0 and Counter Step 1", test_num);
            reset_dut();
            in[3:0] = 4'hA;
            sel = 8'h00;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0001, 4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: MUX Index 10", test_num);
            reset_dut();
            in[43:40] = 4'h7;
            sel = 8'd10;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0001, 4'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Johnson Counter 4-step sequence", test_num);
            reset_dut();
            in = 0;
            sel = 0;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(16'h000F, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: MUX Index 255 (Boundary Test)", test_num);
            reset_dut();
            in[1023:1020] = 4'hE;
            sel = 8'd255;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0001, 4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Johnson Counter reaching FFFF", test_num);
            reset_dut();
            repeat(16) @(posedge clk);
            #1 #1;
 check_outputs(16'hFFFF, 4'h0);
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
        input [15:0] expected_Q;
        input [3:0] expected_out;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, out=%h",
                         Q, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, out=%h",
                         expected_Q, expected_out);
                $display("  Got:      Q=%h, out=%h",
                         Q, out);
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
        $dumpvars(0,clk, in, reset, sel, Q, out);
    end

endmodule
