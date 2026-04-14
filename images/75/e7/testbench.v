`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] RrrGggBbb;
    reg i_VGA_HSync;
    reg i_VGA_VSync;
    wire o_VGA_Blu_0;
    wire o_VGA_Blu_1;
    wire o_VGA_Blu_2;
    wire o_VGA_Grn_0;
    wire o_VGA_Grn_1;
    wire o_VGA_Grn_2;
    wire o_VGA_Red_0;
    wire o_VGA_Red_1;
    wire o_VGA_Red_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RrrGggBbb(RrrGggBbb),
        .i_VGA_HSync(i_VGA_HSync),
        .i_VGA_VSync(i_VGA_VSync),
        .o_VGA_Blu_0(o_VGA_Blu_0),
        .o_VGA_Blu_1(o_VGA_Blu_1),
        .o_VGA_Blu_2(o_VGA_Blu_2),
        .o_VGA_Grn_0(o_VGA_Grn_0),
        .o_VGA_Grn_1(o_VGA_Grn_1),
        .o_VGA_Grn_2(o_VGA_Grn_2),
        .o_VGA_Red_0(o_VGA_Red_0),
        .o_VGA_Red_1(o_VGA_Red_1),
        .o_VGA_Red_2(o_VGA_Red_2)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Active Video - All High", test_num);
            i_VGA_HSync = 1;
            i_VGA_VSync = 1;
            RrrGggBbb = 9'b111_111_111;

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Blanking - HSync Low", test_num);
            i_VGA_HSync = 0;
            i_VGA_VSync = 1;
            RrrGggBbb = 9'b111_111_111;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Blanking - VSync Low", test_num);
            i_VGA_HSync = 1;
            i_VGA_VSync = 0;
            RrrGggBbb = 9'b111_111_111;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Blanking - Both Sync Low", test_num);
            i_VGA_HSync = 0;
            i_VGA_VSync = 0;
            RrrGggBbb = 9'b111_111_111;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Active Video - Pure Red Pattern", test_num);
            i_VGA_HSync = 1;
            i_VGA_VSync = 1;
            RrrGggBbb = 9'b101_000_000;


            #1;



            check_outputs(0, 0, 0, 0, 0, 0, 1, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Active Video - Pure Green Pattern", test_num);
            i_VGA_HSync = 1;
            i_VGA_VSync = 1;
            RrrGggBbb = 9'b000_110_000;

            #1;


            check_outputs(0, 0, 0, 0, 1, 1, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Active Video - Pure Blue Pattern", test_num);
            i_VGA_HSync = 1;
            i_VGA_VSync = 1;
            RrrGggBbb = 9'b000_000_011;

            #1;


            check_outputs(1, 1, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Active Video - Mixed Colors", test_num);
            i_VGA_HSync = 1;
            i_VGA_VSync = 1;
            RrrGggBbb = 9'b110_011_101;



            #1;




            check_outputs(1, 0, 1, 1, 1, 0, 0, 1, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Active Video - Zero Input Color", test_num);
            i_VGA_HSync = 1;
            i_VGA_VSync = 1;
            RrrGggBbb = 9'b000_000_000;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Active Video - Alternating Bits", test_num);
            i_VGA_HSync = 1;
            i_VGA_VSync = 1;
            RrrGggBbb = 9'b101_010_101;

            #1;


            check_outputs(1, 0, 1, 0, 1, 0, 1, 0, 1);
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
        input expected_o_VGA_Blu_0;
        input expected_o_VGA_Blu_1;
        input expected_o_VGA_Blu_2;
        input expected_o_VGA_Grn_0;
        input expected_o_VGA_Grn_1;
        input expected_o_VGA_Grn_2;
        input expected_o_VGA_Red_0;
        input expected_o_VGA_Red_1;
        input expected_o_VGA_Red_2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_VGA_Blu_0 === (expected_o_VGA_Blu_0 ^ o_VGA_Blu_0 ^ expected_o_VGA_Blu_0) &&
                expected_o_VGA_Blu_1 === (expected_o_VGA_Blu_1 ^ o_VGA_Blu_1 ^ expected_o_VGA_Blu_1) &&
                expected_o_VGA_Blu_2 === (expected_o_VGA_Blu_2 ^ o_VGA_Blu_2 ^ expected_o_VGA_Blu_2) &&
                expected_o_VGA_Grn_0 === (expected_o_VGA_Grn_0 ^ o_VGA_Grn_0 ^ expected_o_VGA_Grn_0) &&
                expected_o_VGA_Grn_1 === (expected_o_VGA_Grn_1 ^ o_VGA_Grn_1 ^ expected_o_VGA_Grn_1) &&
                expected_o_VGA_Grn_2 === (expected_o_VGA_Grn_2 ^ o_VGA_Grn_2 ^ expected_o_VGA_Grn_2) &&
                expected_o_VGA_Red_0 === (expected_o_VGA_Red_0 ^ o_VGA_Red_0 ^ expected_o_VGA_Red_0) &&
                expected_o_VGA_Red_1 === (expected_o_VGA_Red_1 ^ o_VGA_Red_1 ^ expected_o_VGA_Red_1) &&
                expected_o_VGA_Red_2 === (expected_o_VGA_Red_2 ^ o_VGA_Red_2 ^ expected_o_VGA_Red_2)) begin
                $display("PASS");
                $display("  Outputs: o_VGA_Blu_0=%b, o_VGA_Blu_1=%b, o_VGA_Blu_2=%b, o_VGA_Grn_0=%b, o_VGA_Grn_1=%b, o_VGA_Grn_2=%b, o_VGA_Red_0=%b, o_VGA_Red_1=%b, o_VGA_Red_2=%b",
                         o_VGA_Blu_0, o_VGA_Blu_1, o_VGA_Blu_2, o_VGA_Grn_0, o_VGA_Grn_1, o_VGA_Grn_2, o_VGA_Red_0, o_VGA_Red_1, o_VGA_Red_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_VGA_Blu_0=%b, o_VGA_Blu_1=%b, o_VGA_Blu_2=%b, o_VGA_Grn_0=%b, o_VGA_Grn_1=%b, o_VGA_Grn_2=%b, o_VGA_Red_0=%b, o_VGA_Red_1=%b, o_VGA_Red_2=%b",
                         expected_o_VGA_Blu_0, expected_o_VGA_Blu_1, expected_o_VGA_Blu_2, expected_o_VGA_Grn_0, expected_o_VGA_Grn_1, expected_o_VGA_Grn_2, expected_o_VGA_Red_0, expected_o_VGA_Red_1, expected_o_VGA_Red_2);
                $display("  Got:      o_VGA_Blu_0=%b, o_VGA_Blu_1=%b, o_VGA_Blu_2=%b, o_VGA_Grn_0=%b, o_VGA_Grn_1=%b, o_VGA_Grn_2=%b, o_VGA_Red_0=%b, o_VGA_Red_1=%b, o_VGA_Red_2=%b",
                         o_VGA_Blu_0, o_VGA_Blu_1, o_VGA_Blu_2, o_VGA_Grn_0, o_VGA_Grn_1, o_VGA_Grn_2, o_VGA_Red_0, o_VGA_Red_1, o_VGA_Red_2);
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
