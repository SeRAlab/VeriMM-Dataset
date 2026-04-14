`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] return_a;
    reg [15:0] return_b;
    reg [15:0] risk_a;
    reg [15:0] risk_b;
    wire choose_a;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .return_a(return_a),
        .return_b(return_b),
        .risk_a(risk_a),
        .risk_b(risk_b),
        .choose_a(choose_a)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Portfolio A higher return, same risk", test_num);
            return_a = 16'd1000;
            risk_a   = 16'd100;
            return_b = 16'd500;
            risk_b   = 16'd100;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Portfolio B lower risk, same return", test_num);
            return_a = 16'd1000;
            risk_a   = 16'd200;
            return_b = 16'd1000;
            risk_b   = 16'd100;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal return-to-risk ratios", test_num);
            return_a = 16'd100;
            risk_a   = 16'd10;
            return_b = 16'd1000;
            risk_b   = 16'd100;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large values (Max Range)", test_num);
            return_a = 16'hFFFF;
            risk_a   = 16'd1;
            return_b = 16'hFFFE;
            risk_b   = 16'd1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High R/R vs Low R/R", test_num);
            return_a = 16'd5000;
            risk_a   = 16'd2500;
            return_b = 16'd10;
            risk_b   = 16'd2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Extreme risk difference", test_num);
            return_a = 16'd1;
            risk_a   = 16'd1;
            return_b = 16'd60000;
            risk_b   = 16'd65535;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Narrow margin difference", test_num);
            return_a = 16'd101;
            risk_a   = 16'd100;
            return_b = 16'd100;
            risk_b   = 16'd100;
            #1;

            check_outputs(1'b1);
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
        input expected_choose_a;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_choose_a === (expected_choose_a ^ choose_a ^ expected_choose_a)) begin
                $display("PASS");
                $display("  Outputs: choose_a=%b",
                         choose_a);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: choose_a=%b",
                         expected_choose_a);
                $display("  Got:      choose_a=%b",
                         choose_a);
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
