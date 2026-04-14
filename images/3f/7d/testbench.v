`timescale 1ns/1ps

module PortfolioOptimization_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] investment1;
    reg [4:0] investment2;
    reg [4:0] investment3;
    wire [4:0] output1;
    wire [4:0] output2;
    wire [4:0] output3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PortfolioOptimization dut (
        .investment1(investment1),
        .investment2(investment2),
        .investment3(investment3),
        .output1(output1),
        .output2(output2),
        .output3(output3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Inputs 5, 10, 15 (Total 30)", test_num);
            investment1 = 5'd5;
            investment2 = 5'd10;
            investment3 = 5'd15;
            #1;

            check_outputs(5'd5, 5'd10, 5'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max inputs 31, 31, 31 (Total 93)", test_num);
            investment1 = 5'd31;
            investment2 = 5'd31;
            investment3 = 5'd31;
            #1;

            check_outputs(5'd10, 5'd10, 5'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Total sum equals scale (10, 11, 10)", test_num);
            investment1 = 5'd10;
            investment2 = 5'd11;
            investment3 = 5'd10;
            #1;

            check_outputs(5'd10, 5'd11, 5'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single investment (20, 0, 0)", test_num);
            investment1 = 5'd20;
            investment2 = 5'd0;
            investment3 = 5'd0;
            #1;

            check_outputs(5'd31, 5'd0, 5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum non-zero sum (1, 0, 0)", test_num);
            investment1 = 5'd1;
            investment2 = 5'd0;
            investment3 = 5'd0;
            #1;

            check_outputs(5'd31, 5'd0, 5'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero inputs (0, 0, 0)", test_num);
            investment1 = 5'd0;
            investment2 = 5'd0;
            investment3 = 5'd0;
            #1;

            check_outputs(5'd0, 5'd0, 5'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Truncation check (8, 8, 8)", test_num);
            investment1 = 5'd8;
            investment2 = 5'd8;
            investment3 = 5'd8;
            #1;

            check_outputs(5'd10, 5'd10, 5'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PortfolioOptimization Testbench");
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
        input [4:0] expected_output1;
        input [4:0] expected_output2;
        input [4:0] expected_output3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output1 === (expected_output1 ^ output1 ^ expected_output1) &&
                expected_output2 === (expected_output2 ^ output2 ^ expected_output2) &&
                expected_output3 === (expected_output3 ^ output3 ^ expected_output3)) begin
                $display("PASS");
                $display("  Outputs: output1=%h, output2=%h, output3=%h",
                         output1, output2, output3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output1=%h, output2=%h, output3=%h",
                         expected_output1, expected_output2, expected_output3);
                $display("  Got:      output1=%h, output2=%h, output3=%h",
                         output1, output2, output3);
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
