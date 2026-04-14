`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [16:0] true;
    wire [16:0] complement;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .true(true),
        .complement(complement)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Input Zero", test_num);
            true = 17'h00000;
            #1;

            check_outputs(17'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Input One", test_num);
            true = 17'h00001;

            #1;


            check_outputs(17'h1FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Input All Ones", test_num);
            true = 17'h1FFFF;

            #1;


            check_outputs(17'h00001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Input Max Positive (Signed Interpretation)", test_num);
            true = 17'h0FFFF;

            #1;


            check_outputs(17'h10001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Input Most Negative (Signed Interpretation)", test_num);
            true = 17'h10000;

            #1;


            check_outputs(17'h10000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Arbitrary Pattern 1 (Alternating Bits)", test_num);
            true = 17'h0AAAA;

            #1;


            check_outputs(17'h15556);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Arbitrary Pattern 2 (Alternating Bits)", test_num);
            true = 17'h15555;

            #1;


            check_outputs(17'h0AAAB);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Power of 2 (Lower Bit)", test_num);
            true = 17'h00004;

            #1;


            check_outputs(17'h1FFFC);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Power of 2 (High Bit)", test_num);
            true = 17'h08000;

            #1;


            check_outputs(17'h18000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Random Distribution", test_num);
            true = 17'h12345;

            #1;


            check_outputs(17'h0DCBB);
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
        input [16:0] expected_complement;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_complement === (expected_complement ^ complement ^ expected_complement)) begin
                $display("PASS");
                $display("  Outputs: complement=%h",
                         complement);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: complement=%h",
                         expected_complement);
                $display("  Got:      complement=%h",
                         complement);
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
