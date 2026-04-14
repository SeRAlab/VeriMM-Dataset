`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] I0;
    reg [31:0] I1;
    reg SEL;
    wire [31:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I0(I0),
        .I1(I1),
        .SEL(SEL),
        .O(O)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select I0 (All Zeros)", test_num);
            I0 = 32'h00000000;
            I1 = 32'hFFFFFFFF;
            SEL = 0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select I1 (All Ones)", test_num);
            I0 = 32'h00000000;
            I1 = 32'hFFFFFFFF;
            SEL = 1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select I0 (Alternating Pattern A)", test_num);
            I0 = 32'hAAAAAAAA;
            I1 = 32'h55555555;
            SEL = 0;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select I1 (Alternating Pattern 5)", test_num);
            I0 = 32'hAAAAAAAA;
            I1 = 32'h55555555;
            SEL = 1;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select I0 (Specific Hex Values)", test_num);
            I0 = 32'hDEADBEEF;
            I1 = 32'hCAFEBABE;
            SEL = 0;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select I1 (Specific Hex Values)", test_num);
            I0 = 32'hDEADBEEF;
            I1 = 32'hCAFEBABE;
            SEL = 1;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select I0 (Walking 1s)", test_num);
            I0 = 32'h00000001;
            I1 = 32'h80000000;
            SEL = 0;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select I1 (Walking 1s)", test_num);
            I0 = 32'h00000001;
            I1 = 32'h80000000;
            SEL = 1;
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
        input [31:0] expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
