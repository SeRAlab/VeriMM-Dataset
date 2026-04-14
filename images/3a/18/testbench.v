`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] intercept;
    reg [7:0] slope;
    reg [7:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .intercept(intercept),
        .slope(slope),
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All inputs zero", test_num);
            slope = 8'h00;
            x = 8'h00;
            intercept = 8'h00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Intercept only (slope and x zero)", test_num);
            slope = 8'h00;
            x = 8'h00;
            intercept = 8'hFF;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Multiplication only (intercept zero)", test_num);
            slope = 8'h0A;
            x = 8'h05;
            intercept = 8'h00;
            #1;

            check_outputs(16'h0032);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Standard linear calculation", test_num);
            slope = 8'h02;
            x = 8'h0A;
            intercept = 8'h05;
            #1;

            check_outputs(16'h0019);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum values", test_num);
            slope = 8'hFF;
            x = 8'hFF;
            intercept = 8'hFF;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large multiplication, small intercept", test_num);
            slope = 8'h80;
            x = 8'h02;
            intercept = 8'h0C;
            #1;

            check_outputs(16'h010C);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Slope is 1", test_num);
            slope = 8'h01;
            x = 8'hC8;
            intercept = 8'h32;
            #1;

            check_outputs(16'h00FA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: x is zero, non-zero slope and intercept", test_num);
            slope = 8'h55;
            x = 8'h00;
            intercept = 8'hAA;
            #1;

            check_outputs(16'h00AA);
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
