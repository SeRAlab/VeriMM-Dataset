`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] i_tuSize;
    reg [8:0] xCtb;
    reg [3:0] xTb_rela;
    reg [8:0] yCtb;
    reg [3:0] yTb_rela;
    wire [2:0] tuSize;
    wire [12:0] xTb;
    wire [12:0] yTb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_tuSize(i_tuSize),
        .xCtb(xCtb),
        .xTb_rela(xTb_rela),
        .yCtb(yCtb),
        .yTb_rela(yTb_rela),
        .tuSize(tuSize),
        .xTb(xTb),
        .yTb(yTb)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All inputs zero", test_num);
            i_tuSize = 3'd2;
            xCtb = 9'd0;
            yCtb = 9'd0;
            xTb_rela = 4'd0;
            yTb_rela = 4'd0;

            #1;


            check_outputs(3'd1, 13'h0000, 13'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum input values", test_num);
            i_tuSize = 3'd5;
            xCtb = 9'h1FF;
            yCtb = 9'h1FF;
            xTb_rela = 4'hF;
            yTb_rela = 4'hF;

            #1;


            check_outputs(3'd4, 13'h1FFF, 13'h1FFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mid-frame CTB position", test_num);
            i_tuSize = 3'd3;
            xCtb = 9'h0A5;
            yCtb = 9'h03C;
            xTb_rela = 4'h8;
            yTb_rela = 4'h4;

            #1;


            check_outputs(3'd2, 13'h0A58, 13'h03C4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Minimum TU size adjustment", test_num);
            i_tuSize = 3'd1;
            xCtb = 9'h010;
            yCtb = 9'h020;
            xTb_rela = 4'h2;
            yTb_rela = 4'h1;

            #1;


            check_outputs(3'd0, 13'h0102, 13'h0201);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: High relative offsets", test_num);
            i_tuSize = 3'd4;
            xCtb = 9'h080;
            yCtb = 9'h080;
            xTb_rela = 4'hE;
            yTb_rela = 4'hB;

            #1;


            check_outputs(3'd3, 13'h080E, 13'h080B);
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
        input [2:0] expected_tuSize;
        input [12:0] expected_xTb;
        input [12:0] expected_yTb;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_tuSize === (expected_tuSize ^ tuSize ^ expected_tuSize) &&
                expected_xTb === (expected_xTb ^ xTb ^ expected_xTb) &&
                expected_yTb === (expected_yTb ^ yTb ^ expected_yTb)) begin
                $display("PASS");
                $display("  Outputs: tuSize=%h, xTb=%h, yTb=%h",
                         tuSize, xTb, yTb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tuSize=%h, xTb=%h, yTb=%h",
                         expected_tuSize, expected_xTb, expected_yTb);
                $display("  Got:      tuSize=%h, xTb=%h, yTb=%h",
                         tuSize, xTb, yTb);
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
