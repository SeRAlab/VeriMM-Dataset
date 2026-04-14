`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] b;
    reg [15:0] m;
    reg [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .b(b),
        .m(m),
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero (y = 0*0 + 0)", test_num);
            m = 16'h0000;
            x = 16'h0000;
            b = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic linear (y = 1*10 + 5)", test_num);
            m = 16'd1;
            x = 16'd10;
            b = 16'd5;
            #1;

            check_outputs(16'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: m=0, b=constant (y = 0*x + 100)", test_num);
            m = 16'd0;
            x = 16'd55;
            b = 16'd100;
            #1;

            check_outputs(16'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large positive values (y = 100*200 + 500)", test_num);
            m = 16'd100;
            x = 16'd200;
            b = 16'd500;
            #1;

            check_outputs(16'd20500);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative slope (y = -2*10 + 30)", test_num);
            m = -16'sd2;
            x = 16'sd10;
            b = 16'sd30;
            #1;

            check_outputs(16'sd10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative input and intercept (y = 5*-3 + -10)", test_num);
            m = 16'sd5;
            x = -16'sd3;
            b = -16'sd10;
            #1;

            check_outputs(-16'sd25);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two negative factors (y = -4*-5 + 10)", test_num);
            m = -16'sd4;
            x = -16'sd5;
            b = 16'sd10;
            #1;

            check_outputs(16'sd30);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max positive range result (y = 32767*1 + 0)", test_num);
            m = 16'sh7FFF;
            x = 16'sd1;
            b = 16'sd0;
            #1;

            check_outputs(16'sh7FFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linear_regression Testbench");
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
        input [15:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
