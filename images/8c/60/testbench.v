`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] immed;
    wire [31:0] extended;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .immed(immed),
        .extended(extended)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All Zeros", test_num);
            immed = 16'h0000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Small Positive Value", test_num);
            immed = 16'h0001;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Max Positive Signed 16-bit", test_num);
            immed = 16'h7FFF;
            #1;

            check_outputs(32'h00007FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Most Negative Signed 16-bit", test_num);
            immed = 16'h8000;
            #1;

            check_outputs(32'hFFFF8000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: All Ones (-1)", test_num);
            immed = 16'hFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Arbitrary Positive Value", test_num);
            immed = 16'h4321;
            #1;

            check_outputs(32'h00004321);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Arbitrary Negative Value", test_num);
            immed = 16'hABCD;
            #1;

            check_outputs(32'hFFFFABCD);
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
        input [31:0] expected_extended;
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
