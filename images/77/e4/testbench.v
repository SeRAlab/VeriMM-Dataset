`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [16:0] inputImed;
    wire [31:0] outputImed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inputImed(inputImed),
        .outputImed(outputImed)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive Zero", test_num);
            inputImed = 17'h00000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Positive Value", test_num);
            inputImed = 17'h0FFFF;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Smallest Negative Value (Sign Bit 1)", test_num);
            inputImed = 17'h10000;
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones (Negative One)", test_num);
            inputImed = 17'h1FFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arbitrary Positive Value", test_num);
            inputImed = 17'h05A5A;
            #1;

            check_outputs(32'h00005A5A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arbitrary Negative Value", test_num);
            inputImed = 17'h1A5A5;
            #1;

            check_outputs(32'hFFFFA5A5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits Positive", test_num);
            inputImed = 17'h0AAAA;
            #1;

            check_outputs(32'h0000AAAA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits Negative", test_num);
            inputImed = 17'h15555;
            #1;

            check_outputs(32'hFFFF5555);
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
        input [31:0] expected_outputImed;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outputImed === (expected_outputImed ^ outputImed ^ expected_outputImed)) begin
                $display("PASS");
                $display("  Outputs: outputImed=%h",
                         outputImed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outputImed=%h",
                         expected_outputImed);
                $display("  Got:      outputImed=%h",
                         outputImed);
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
