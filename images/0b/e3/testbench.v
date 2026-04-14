`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] G;
    reg [15:0] LR;
    reg [15:0] X;
    wire [15:0] X_new;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .G(G),
        .LR(LR),
        .X(X),
        .X_new(X_new)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple subtraction", test_num);
            X = 16'd100;
            LR = 16'd2;
            G = 16'd10;

            #1;


            check_outputs(16'd80);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Learning Rate", test_num);
            X = 16'hA5A5;
            LR = 16'd0;
            G = 16'hFFFF;

            #1;


            check_outputs(16'hA5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Result becomes Zero", test_num);
            X = 16'd500;
            LR = 16'd5;
            G = 16'd100;

            #1;


            check_outputs(16'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Underflow (Negative Result Wrap-around)", test_num);
            X = 16'd10;
            LR = 16'd5;
            G = 16'd4;

            #1;


            check_outputs(16'hFFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Gradient", test_num);
            X = 16'h1234;
            LR = 16'hFFFF;
            G = 16'd0;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large Values with Multiplier truncation", test_num);

            X = 16'h0000;
            LR = 16'h0100;
            G = 16'h0100;


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Values subtraction", test_num);
            X = 16'hFFFF;
            LR = 16'd1;
            G = 16'd1;

            #1;


            check_outputs(16'hFFFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: LR=1 check", test_num);
            X = 16'd1000;
            LR = 16'd1;
            G = 16'd450;

            #1;


            check_outputs(16'd550);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gradient_descent Testbench");
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
        input [15:0] expected_X_new;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X_new === (expected_X_new ^ X_new ^ expected_X_new)) begin
                $display("PASS");
                $display("  Outputs: X_new=%h",
                         X_new);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X_new=%h",
                         expected_X_new);
                $display("  Got:      X_new=%h",
                         X_new);
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
