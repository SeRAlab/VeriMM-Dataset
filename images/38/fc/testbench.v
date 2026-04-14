`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] x;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    polynomial_evaluator dut (
        .a(a),
        .b(b),
        .c(c),
        .x(x),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            a = 8'd0; b = 8'd0; c = 8'd0; x = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x is zero (result should be c)", test_num);
            a = 8'd10; b = 8'd20; c = 8'd45; x = 8'd0;
            #1;

            check_outputs(16'd45);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a and b are zero (constant function)", test_num);
            a = 8'd0; b = 8'd0; c = 8'd255; x = 8'd123;
            #1;

            check_outputs(16'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a is zero (linear function)", test_num);
            a = 8'd0; b = 8'd10; c = 8'd5; x = 8'd50;
            #1;

            check_outputs(16'd505);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x is 1 (sum of coefficients)", test_num);
            a = 8'd5; b = 8'd10; c = 8'd15; x = 8'd1;
            #1;

            check_outputs(16'd30);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small values quadratic", test_num);
            a = 8'd2; b = 8'd3; c = 8'd4; x = 8'd5;
            #1;

            check_outputs(16'd69);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large x, a=1", test_num);
            a = 8'd1; b = 8'd0; c = 8'd0; x = 8'd255;
            #1;

            check_outputs(16'd65025);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large linear part", test_num);
            a = 8'd0; b = 8'd255; c = 8'd255; x = 8'd255;
            #1;

            check_outputs(16'd65535);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range calculation", test_num);
            a = 8'd3; b = 8'd12; c = 8'd1; x = 8'd20;
            #1;

            check_outputs(16'd1441);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow handling (16-bit truncation)", test_num);

            a = 8'd2; b = 8'd0; c = 8'd0; x = 8'd200;
            #1;

            check_outputs(16'd14464);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("polynomial_evaluator Testbench");
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
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
