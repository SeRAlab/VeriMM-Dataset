`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] i_Binary_Num;
    reg i_Clk;
    wire o_Segment_A;
    wire o_Segment_B;
    wire o_Segment_C;
    wire o_Segment_D;
    wire o_Segment_E;
    wire o_Segment_F;
    wire o_Segment_G;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_Binary_Num(i_Binary_Num),
        .i_Clk(i_Clk),
        .o_Segment_A(o_Segment_A),
        .o_Segment_B(o_Segment_B),
        .o_Segment_C(o_Segment_C),
        .o_Segment_D(o_Segment_D),
        .o_Segment_E(o_Segment_E),
        .o_Segment_F(o_Segment_F),
        .o_Segment_G(o_Segment_G)
    );

    // Clock generation (10ns period)
    initial begin
        i_Clk = 0;
        forever #5 i_Clk = ~i_Clk;
    end

        task reset_dut;

        begin
            i_Binary_Num = 4'b0000;
            @(posedge i_Clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            i_Binary_Num = 4'h0;
            @(posedge i_Clk);
            #2;
            $display("Testcase %0d: Input 4'h0 (0)", test_num);
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            i_Binary_Num = 4'h1;
            @(posedge i_Clk);
            #2;
            $display("Testcase %0d: Input 4'h1 (1)", test_num);
            #1;

            check_outputs(0, 1, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            i_Binary_Num = 4'h4;
            @(posedge i_Clk);
            #2;
            $display("Testcase %0d: Input 4'h4 (4)", test_num);
            #1;

            check_outputs(0, 1, 1, 0, 0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            i_Binary_Num = 4'h7;
            @(posedge i_Clk);
            #2;
            $display("Testcase %0d: Input 4'h7 (7)", test_num);
            #1;

            check_outputs(1, 1, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            i_Binary_Num = 4'h8;
            @(posedge i_Clk);
            #2;
            $display("Testcase %0d: Input 4'h8 (8)", test_num);
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            i_Binary_Num = 4'hA;
            @(posedge i_Clk);
            #2;
            $display("Testcase %0d: Input 4'hA (10)", test_num);
            #1;

            check_outputs(1, 1, 1, 0, 1, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            i_Binary_Num = 4'hE;
            @(posedge i_Clk);
            #2;
            $display("Testcase %0d: Input 4'hE (14)", test_num);
            #1;

            check_outputs(1, 0, 0, 1, 1, 1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            i_Binary_Num = 4'hF;
            @(posedge i_Clk);
            #2;
            $display("Testcase %0d: Input 4'hF (15)", test_num);
            #1;

            check_outputs(1, 0, 0, 0, 1, 1, 1);
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
        input expected_o_Segment_A;
        input expected_o_Segment_B;
        input expected_o_Segment_C;
        input expected_o_Segment_D;
        input expected_o_Segment_E;
        input expected_o_Segment_F;
        input expected_o_Segment_G;
        begin
            if (expected_o_Segment_A === (expected_o_Segment_A ^ o_Segment_A ^ expected_o_Segment_A) &&
                expected_o_Segment_B === (expected_o_Segment_B ^ o_Segment_B ^ expected_o_Segment_B) &&
                expected_o_Segment_C === (expected_o_Segment_C ^ o_Segment_C ^ expected_o_Segment_C) &&
                expected_o_Segment_D === (expected_o_Segment_D ^ o_Segment_D ^ expected_o_Segment_D) &&
                expected_o_Segment_E === (expected_o_Segment_E ^ o_Segment_E ^ expected_o_Segment_E) &&
                expected_o_Segment_F === (expected_o_Segment_F ^ o_Segment_F ^ expected_o_Segment_F) &&
                expected_o_Segment_G === (expected_o_Segment_G ^ o_Segment_G ^ expected_o_Segment_G)) begin
                $display("PASS");
                $display("  Outputs: o_Segment_A=%b, o_Segment_B=%b, o_Segment_C=%b, o_Segment_D=%b, o_Segment_E=%b, o_Segment_F=%b, o_Segment_G=%b",
                         o_Segment_A, o_Segment_B, o_Segment_C, o_Segment_D, o_Segment_E, o_Segment_F, o_Segment_G);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_Segment_A=%b, o_Segment_B=%b, o_Segment_C=%b, o_Segment_D=%b, o_Segment_E=%b, o_Segment_F=%b, o_Segment_G=%b",
                         expected_o_Segment_A, expected_o_Segment_B, expected_o_Segment_C, expected_o_Segment_D, expected_o_Segment_E, expected_o_Segment_F, expected_o_Segment_G);
                $display("  Got:      o_Segment_A=%b, o_Segment_B=%b, o_Segment_C=%b, o_Segment_D=%b, o_Segment_E=%b, o_Segment_F=%b, o_Segment_G=%b",
                         o_Segment_A, o_Segment_B, o_Segment_C, o_Segment_D, o_Segment_E, o_Segment_F, o_Segment_G);
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
        $dumpvars(0,i_Binary_Num, i_Clk, o_Segment_A, o_Segment_B, o_Segment_C, o_Segment_D, o_Segment_E, o_Segment_F, o_Segment_G);
    end

endmodule
