`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] choose;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg [7:0] in4;
    reg [7:0] in5;
    reg [7:0] in6;
    reg [7:0] in7;
    reg [7:0] in8;
    reg sel;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .choose(choose),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .in8(in8),
        .sel(sel),
        .out(out)
    );
    task assign_inputs;

        begin
            in1 = 8'h11; in2 = 8'h22; in3 = 8'h33; in4 = 8'h44;
            in5 = 8'h55; in6 = 8'h66; in7 = 8'h77; in8 = 8'h88;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test 001: sel=0, choose=0 -> Expected {in1, in2}");
            assign_inputs();
            sel = 0; choose = 3'd0;
            #1;

            check_outputs(16'h1122);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test 002: sel=0, choose=1 -> Expected {in3, in4}");
            assign_inputs();
            sel = 0; choose = 3'd1;
            #1;

            check_outputs(16'h3344);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test 003: sel=0, choose=2 -> Expected {in5, in6}");
            assign_inputs();
            sel = 0; choose = 3'd2;
            #1;

            check_outputs(16'h5566);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test 004: sel=0, choose=3 -> Expected {in7, in8}");
            assign_inputs();
            sel = 0; choose = 3'd3;
            #1;

            check_outputs(16'h7788);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test 005: sel=1, choose=0 -> Expected Combination 1 {in1, in5}");
            assign_inputs();
            sel = 1; choose = 3'd0;
            #1;

            check_outputs(16'h1155);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test 006: sel=1, choose=1 -> Expected Combination 2 {in2, in6}");
            assign_inputs();
            sel = 1; choose = 3'd1;
            #1;

            check_outputs(16'h2266);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test 007: sel=1, choose=2 -> Expected Combination 3 {in3, in7}");
            assign_inputs();
            sel = 1; choose = 3'd2;
            #1;

            check_outputs(16'h3377);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test 008: sel=1, choose=3 -> Expected Combination 4 {in4, in8}");
            assign_inputs();
            sel = 1; choose = 3'd3;
            #1;

            check_outputs(16'h4488);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test 009: Default Case - sel=0, choose=7");
            assign_inputs();
            sel = 0; choose = 3'd7;

            #1;


            check_outputs(16'h0000);
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
