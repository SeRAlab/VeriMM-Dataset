`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] imm;
    wire [63:0] extended;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .imm(imm),
        .extended(extended)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero input", test_num);
            imm = 12'h000;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum positive value (0x7FF)", test_num);
            imm = 12'h7FF;
            #1;

            check_outputs(64'h00000000000007FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum negative value (0x800)", test_num);
            imm = 12'h800;
            #1;

            check_outputs(64'hFFFFFFFFFFFFF800);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative one (0xFFF)", test_num);
            imm = 12'hFFF;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arbitrary positive value (0x123)", test_num);
            imm = 12'h123;
            #1;

            check_outputs(64'h0000000000000123);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arbitrary negative value (0xA5A)", test_num);
            imm = 12'hA5A;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFA5A);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive boundary (0x001)", test_num);
            imm = 12'h001;
            #1;

            check_outputs(64'h0000000000000001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative boundary (0xFFE)", test_num);
            imm = 12'hFFE;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFE);
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
        input [63:0] expected_extended;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_extended === (expected_extended ^ extended ^ expected_extended)) begin
                $display("PASS");
                $display("  Outputs: extended=%h",
                         extended);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: extended=%h",
                         expected_extended);
                $display("  Got:      extended=%h",
                         extended);
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
