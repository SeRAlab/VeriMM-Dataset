`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a0;
    reg [3:0] a1;
    reg [3:0] a2;
    reg [3:0] a3;
    reg [3:0] x;
    wire [7:0] result;

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
        .x(x),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All zeros", test_num);
            a0 = 4'd0; a1 = 4'd0; a2 = 4'd0; a3 = 4'd0; x = 4'd5;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Constant term only", test_num);
            a0 = 4'd12; a1 = 4'd0; a2 = 4'd0; a3 = 4'd0; x = 4'd10;

            #1;


            check_outputs(8'd12);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Linear and Quadratic terms", test_num);
            a0 = 4'd1; a1 = 4'd2; a2 = 4'd3; a3 = 4'd0; x = 4'd2;

            #1;


            check_outputs(8'd17);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: x=1 (Sum of coefficients)", test_num);
            a0 = 4'd5; a1 = 4'd5; a2 = 4'd5; a3 = 4'd5; x = 4'd1;

            #1;


            check_outputs(8'd20);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Full cubic evaluation", test_num);
            a0 = 4'd10; a1 = 4'd5; a2 = 4'd2; a3 = 4'd1; x = 4'd3;

            #1;


            check_outputs(8'd70);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed coefficients", test_num);
            a0 = 4'd3; a1 = 4'd2; a2 = 4'd5; a3 = 4'd1; x = 4'd2;

            #1;


            check_outputs(8'd35);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Result close to 255", test_num);
            a0 = 4'd15; a1 = 4'd15; a2 = 4'd1; a3 = 4'd0; x = 4'd15;


            #1;



            check_outputs(8'hD1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Significant overflow", test_num);
            a0 = 4'd0; a1 = 4'd0; a2 = 4'd0; a3 = 4'd5; x = 4'd4;


            #1;



            check_outputs(8'h40);
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
        input [7:0] expected_result;
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
