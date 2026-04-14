`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] regValFRm;
    wire [63:0] regValFRn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .regValFRm(regValFRm),
        .regValFRn(regValFRn)
    );
    task testcase001;

        begin
            test_num = 1;
            regValFRm = 32'h0000_0000;
            $display("Test %0d: Positive Zero", test_num);
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            regValFRm = 32'h8000_0000;
            $display("Test %0d: Negative Zero", test_num);
            #1;

            check_outputs(64'h8000_0000_0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            regValFRm = 32'h3F80_0000;
            $display("Test %0d: Positive One (1.0)", test_num);
            #1;

            check_outputs(64'h3FF0_0000_0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            regValFRm = 32'hC000_0000;
            $display("Test %0d: Negative Two (-2.0)", test_num);
            #1;

            check_outputs(64'hC000_0000_0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            regValFRm = 32'h7F80_0000;
            $display("Test %0d: Positive Infinity", test_num);
            #1;

            check_outputs(64'h7FF0_0000_0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            regValFRm = 32'hFF80_0000;
            $display("Test %0d: Negative Infinity", test_num);
            #1;

            check_outputs(64'hFFF0_0000_0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            regValFRm = 32'h7FC0_0000;
            $display("Test %0d: NaN", test_num);
            #1;

            check_outputs(64'h7FF8_0000_0000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            regValFRm = 32'h0080_0000;
            $display("Test %0d: Smallest Positive Normal", test_num);
            #1;

            check_outputs(64'h3810_0000_0000_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            regValFRm = 32'h7F7F_FFFF;
            $display("Test %0d: Largest Positive Normal", test_num);
            #1;

            check_outputs(64'h47EF_FFFF_E000_0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            regValFRm = 32'h3FC0_0000;
            $display("Test %0d: Normal Number (1.5)", test_num);
            #1;

            check_outputs(64'h3FF8_0000_0000_0000);
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
        input [63:0] expected_regValFRn;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_regValFRn === (expected_regValFRn ^ regValFRn ^ expected_regValFRn)) begin
                $display("PASS");
                $display("  Outputs: regValFRn=%h",
                         regValFRn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: regValFRn=%h",
                         expected_regValFRn);
                $display("  Got:      regValFRn=%h",
                         regValFRn);
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
