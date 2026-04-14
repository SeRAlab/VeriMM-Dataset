`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a0;
    reg [7:0] a1;
    reg [7:0] a2;
    reg [7:0] a3;
    reg [7:0] a4;
    reg [3:0] x;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    polynomial_evaluator dut (
        .a0(a0),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .a4(a4),
        .x(x),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: x=0 (Result should be a0)", test_num);
            a0 = 8'd25;
            a1 = 8'd10;
            a2 = 8'd5;
            a3 = 8'd2;
            a4 = 8'd1;
            x  = 4'd0;

            #1;


            check_outputs(16'd25);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: x=1 (Result should be sum of coefficients)", test_num);
            a0 = 8'd1;
            a1 = 8'd2;
            a2 = 8'd3;
            a3 = 8'd4;
            a4 = 8'd5;
            x  = 4'd1;

            #1;


            check_outputs(16'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: All coefficients zero", test_num);
            a0 = 8'd0;
            a1 = 8'd0;
            a2 = 8'd0;
            a3 = 8'd0;
            a4 = 8'd0;
            x  = 4'd15;

            #1;


            check_outputs(16'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Linear polynomial P(x) = 10 + 2x", test_num);
            a0 = 8'd10;
            a1 = 8'd2;
            a2 = 8'd0;
            a3 = 8'd0;
            a4 = 8'd0;
            x  = 4'd5;

            #1;


            check_outputs(16'd20);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Quadratic polynomial P(x) = 1 + x + x^2", test_num);
            a0 = 8'd1;
            a1 = 8'd1;
            a2 = 8'd1;
            a3 = 8'd0;
            a4 = 8'd0;
            x  = 4'd4;

            #1;


            check_outputs(16'd21);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Cubic term check", test_num);
            a0 = 8'd0;
            a1 = 8'd0;
            a2 = 8'd0;
            a3 = 8'd2;
            a4 = 8'd0;
            x  = 4'd3;

            #1;


            check_outputs(16'd54);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Quartic term check", test_num);
            a0 = 8'd0;
            a1 = 8'd0;
            a2 = 8'd0;
            a3 = 8'd0;
            a4 = 8'd1;
            x  = 4'd4;

            #1;


            check_outputs(16'd256);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Full polynomial calculation", test_num);
            a0 = 8'd5;
            a1 = 8'd4;
            a2 = 8'd3;
            a3 = 8'd2;
            a4 = 8'd1;
            x  = 4'd2;


            #1;



            check_outputs(16'd57);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Large coefficients, large x (Checking 16-bit truncation)", test_num);
            a0 = 8'd255;
            a1 = 8'd255;
            a2 = 8'd255;
            a3 = 8'd255;
            a4 = 8'd255;
            x  = 4'd15;



            #1;




            check_outputs(16'h0D1F);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Max x value with single coefficient", test_num);
            a0 = 8'd0;
            a1 = 8'd0;
            a2 = 8'd10;
            a3 = 8'd0;
            a4 = 8'd0;
            x  = 4'd15;

            #1;


            check_outputs(16'd2250);
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
