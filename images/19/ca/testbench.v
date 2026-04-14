`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] return_A;
    reg [7:0] return_B;
    reg [7:0] risk_A;
    reg [7:0] risk_B;
    wire decision_A;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .return_A(return_A),
        .return_B(return_B),
        .risk_A(risk_A),
        .risk_B(risk_B),
        .decision_A(decision_A)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Asset A higher return, lower risk", test_num);
            return_A = 8'd100; risk_A = 8'd10;
            return_B = 8'd50;  risk_B = 8'd20;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Asset B higher return, lower risk", test_num);
            return_A = 8'd40;  risk_A = 8'd30;
            return_B = 8'd120; risk_B = 8'd15;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal returns, A lower risk", test_num);
            return_A = 8'd80; risk_A = 8'd10;
            return_B = 8'd80; risk_B = 8'd20;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal risks, B higher return", test_num);
            return_A = 8'd60;  risk_A = 8'd20;
            return_B = 8'd100; risk_B = 8'd20;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal Sharpe ratios (Tie)", test_num);
            return_A = 8'd100; risk_A = 8'd50;
            return_B = 8'd50;  risk_B = 8'd25;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Risk/Return (A) wins on ratio", test_num);
            return_A = 8'd200; risk_A = 8'd40;
            return_B = 8'd40;  risk_B = 8'd20;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Low Risk/Return (B) wins on ratio", test_num);
            return_A = 8'd100; risk_A = 8'd50;
            return_B = 8'd30;  risk_B = 8'd5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Near maximum values", test_num);
            return_A = 8'd255; risk_A = 8'd128;
            return_B = 8'd200; risk_B = 8'd100;
            #1;

            check_outputs(1'b0);
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
        input expected_decision_A;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decision_A === (expected_decision_A ^ decision_A ^ expected_decision_A)) begin
                $display("PASS");
                $display("  Outputs: decision_A=%b",
                         decision_A);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decision_A=%b",
                         expected_decision_A);
                $display("  Got:      decision_A=%b",
                         decision_A);
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
