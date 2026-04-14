`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] risk_levels;
    reg [4:0] threshold;
    wire [4:0] decision;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .risk_levels(risk_levels),
        .threshold(threshold),
        .decision(decision)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            risk_levels = 5'b00000;
            threshold = 5'b00000;
            $display("Test Case 001: All risks 0, all thresholds 0 (Equal - Should pass)");
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            risk_levels = 5'b11111;
            threshold = 5'b11111;
            $display("Test Case 002: All risks 1, all thresholds 1 (Equal - Should pass)");
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            risk_levels = 5'b11111;
            threshold = 5'b00000;
            $display("Test Case 003: All risks high, all thresholds low (All should fail)");
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            risk_levels = 5'b00000;
            threshold = 5'b11111;
            $display("Test Case 004: All risks low, all thresholds high (All should pass)");
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            risk_levels = 5'b10101;
            threshold   = 5'b01010;
            $display("Test Case 005: Alternating bits (Expected decision: 01010)");

            #1;


            check_outputs(5'b01010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            risk_levels = 5'b01010;
            threshold   = 5'b10101;
            $display("Test Case 006: Alternating bits inverted (Expected decision: 11111)");



            #1;




            check_outputs(5'b10101);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            risk_levels = 5'b11011;
            threshold   = 5'b11111;
            $display("Test Case 007: One asset at low risk, others high");
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            risk_levels = 5'b11111;
            threshold   = 5'b00100;
            $display("Test Case 008: Only asset 2 has a high threshold");

            #1;


            check_outputs(5'b00100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("portfolio_optimizer Testbench");
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
        input [4:0] expected_decision;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decision === (expected_decision ^ decision ^ expected_decision)) begin
                $display("PASS");
                $display("  Outputs: decision=%h",
                         decision);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decision=%h",
                         expected_decision);
                $display("  Got:      decision=%h",
                         decision);
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
