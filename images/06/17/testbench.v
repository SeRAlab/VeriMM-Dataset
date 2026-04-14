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
            $display("Test %0d: All inputs zero (f(0) = 0*0^2 + 0*0 + 0)", test_num);
            a = 8'd0; b = 8'd0; c = 8'd0; x = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: x is zero (f(0) = 1*0^2 + 2*0 + 15)", test_num);
            a = 8'd1; b = 8'd2; c = 8'd15; x = 8'd0;
            #1;

            check_outputs(16'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Linear function (f(5) = 0*x^2 + 10*5 + 5)", test_num);
            a = 8'd0; b = 8'd10; c = 8'd5; x = 8'd5;
            #1;

            check_outputs(16'd55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pure quadratic (f(4) = 2*4^2 + 0*4 + 0)", test_num);
            a = 8'd2; b = 8'd0; c = 8'd0; x = 8'd4;
            #1;

            check_outputs(16'd32);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full polynomial (f(3) = 2*3^2 + 4*3 + 1)", test_num);
            a = 8'd2; b = 8'd4; c = 8'd1; x = 8'd3;

            #1;


            check_outputs(16'd31);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Medium values (f(10) = 5*10^2 + 3*10 + 20)", test_num);
            a = 8'd5; b = 8'd3; c = 8'd20; x = 8'd10;

            #1;


            check_outputs(16'd550);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High x value (f(255) = 1*255^2 + 1*255 + 1)", test_num);
            a = 8'd1; b = 8'd1; c = 8'd1; x = 8'd255;

            #1;


            check_outputs(16'hFF01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow/Wrap check (f(200) = 2*200^2 + 0 + 0)", test_num);
            a = 8'd2; b = 8'd0; c = 8'd0; x = 8'd200;


            #1;



            check_outputs(16'h3880);
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
