`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] In_0;
    reg [15:0] In_1;
    reg select;
    wire [15:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In_0(In_0),
        .In_1(In_1),
        .select(select),
        .Out(Out)
    );
    task testcase001;

        begin
            test_num = 1;
            In_0 = 16'hA5A5;
            In_1 = 16'h5A5A;
            select = 1'b0;
            $display("Test %0d: Select In_0 (A5A5)", test_num);
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            In_0 = 16'hA5A5;
            In_1 = 16'h5A5A;
            select = 1'b1;
            $display("Test %0d: Select In_1 (5A5A)", test_num);
            #1;

            check_outputs(16'h5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            In_0 = 16'hFFFF;
            In_1 = 16'h0000;
            select = 1'b0;
            $display("Test %0d: Select In_0 (FFFF)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            In_0 = 16'hFFFF;
            In_1 = 16'h0000;
            select = 1'b1;
            $display("Test %0d: Select In_1 (0000)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            In_0 = 16'h1234;
            In_1 = 16'h4321;
            select = 1'b0;
            $display("Test %0d: Select In_0 (1234)", test_num);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            In_0 = 16'h1234;
            In_1 = 16'h4321;
            select = 1'b1;
            $display("Test %0d: Select In_1 (4321)", test_num);
            #1;

            check_outputs(16'h4321);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            In_0 = 16'hF0F0;
            In_1 = 16'h0F0F;
            select = 1'b0;
            $display("Test %0d: Select In_0 (F0F0)", test_num);
            #1;

            check_outputs(16'hF0F0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            In_0 = 16'hF0F0;
            In_1 = 16'h0F0F;
            select = 1'b1;
            $display("Test %0d: Select In_1 (0F0F)", test_num);
            #1;

            check_outputs(16'h0F0F);
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
        input [15:0] expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
