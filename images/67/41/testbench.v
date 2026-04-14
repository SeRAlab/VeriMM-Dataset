`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] INPUT1;
    reg [31:0] INPUT2;
    reg SELECT;
    wire [31:0] RESULT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .INPUT1(INPUT1),
        .INPUT2(INPUT2),
        .SELECT(SELECT),
        .RESULT(RESULT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select INPUT1 (0xAAAAAAAA) with SELECT=0", test_num);
            INPUT1 = 32'hAAAAAAAA;
            INPUT2 = 32'h55555555;
            SELECT = 1'b0;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select INPUT2 (0x55555555) with SELECT=1", test_num);
            INPUT1 = 32'hAAAAAAAA;
            INPUT2 = 32'h55555555;
            SELECT = 1'b1;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select INPUT1 (All Fs) with SELECT=0", test_num);
            INPUT1 = 32'hFFFFFFFF;
            INPUT2 = 32'h00000000;
            SELECT = 1'b0;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select INPUT2 (All 0s) with SELECT=1", test_num);
            INPUT1 = 32'hFFFFFFFF;
            INPUT2 = 32'h00000000;
            SELECT = 1'b1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Routing Test (INPUT1=0x12345678, SELECT=0)", test_num);
            INPUT1 = 32'h12345678;
            INPUT2 = 32'h9ABCDEF0;
            SELECT = 1'b0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Routing Test (INPUT2=0x9ABCDEF0, SELECT=1)", test_num);
            INPUT1 = 32'h12345678;
            INPUT2 = 32'h9ABCDEF0;
            SELECT = 1'b1;
            #1;

            check_outputs(32'h9ABCDEF0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Test (INPUT1=0x0, INPUT2=0xFFFFFFFF, SELECT=0)", test_num);
            INPUT1 = 32'h00000000;
            INPUT2 = 32'hFFFFFFFF;
            SELECT = 1'b0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Walking Bit Test (INPUT1=0x80000000, SELECT=0)", test_num);
            INPUT1 = 32'h80000000;
            INPUT2 = 32'h00000001;
            SELECT = 1'b0;
            #1;

            check_outputs(32'h80000000);
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
        input [31:0] expected_RESULT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT)) begin
                $display("PASS");
                $display("  Outputs: RESULT=%h",
                         RESULT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RESULT=%h",
                         expected_RESULT);
                $display("  Got:      RESULT=%h",
                         RESULT);
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
