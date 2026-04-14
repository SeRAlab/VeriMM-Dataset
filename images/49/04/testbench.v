`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] IMM;
    wire [7:0] SEXT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IMM(IMM),
        .SEXT(SEXT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Zero", test_num);
            IMM = 6'b000000;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Positive Value", test_num);
            IMM = 6'b011111;
            #1;

            check_outputs(8'h1F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Smallest Positive Value", test_num);
            IMM = 6'b000001;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum Negative Value (Most Negative)", test_num);
            IMM = 6'b100000;
            #1;

            check_outputs(8'hE0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Negative Value (-1)", test_num);
            IMM = 6'b111111;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Positive Value", test_num);
            IMM = 6'b001010;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Negative Value", test_num);
            IMM = 6'b110110;
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Positive", test_num);
            IMM = 6'b010101;
            #1;

            check_outputs(8'h15);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Negative", test_num);
            IMM = 6'b101010;
            #1;

            check_outputs(8'hEA);
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
        input [7:0] expected_SEXT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SEXT === (expected_SEXT ^ SEXT ^ expected_SEXT)) begin
                $display("PASS");
                $display("  Outputs: SEXT=%h",
                         SEXT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SEXT=%h",
                         expected_SEXT);
                $display("  Got:      SEXT=%h",
                         SEXT);
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
