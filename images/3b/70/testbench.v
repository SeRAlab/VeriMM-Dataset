`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a0;
    reg [15:0] a1;
    reg [15:0] a2;
    reg [15:0] a3;
    reg [7:0] x;
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
        .x(x),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            a0 = 0; a1 = 0; a2 = 0; a3 = 0; x = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x is zero (Result should be a0)", test_num);
            a0 = 16'hABCD; a1 = 16'h1234; a2 = 16'h5678; a3 = 16'h9999; x = 8'h00;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x is 1 (Result is sum of coefficients)", test_num);
            a0 = 16'h0001; a1 = 16'h0002; a2 = 16'h0003; a3 = 16'h0004; x = 8'h01;
            #1;

            check_outputs(16'h000A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple small values", test_num);
            a0 = 16'd10; a1 = 16'd5; a2 = 16'd2; a3 = 16'd1; x = 8'd3;

            #1;


            check_outputs(16'd70);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sum overflow check", test_num);
            a0 = 16'h8000; a1 = 16'h8000; a2 = 0; a3 = 0; x = 1;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing x^3 term", test_num);
            a0 = 0; a1 = 0; a2 = 0; a3 = 16'd1; x = 8'd10;

            #1;


            check_outputs(16'd1000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing x^2 term with large x", test_num);
            a0 = 0; a1 = 0; a2 = 16'd1; a3 = 0; x = 8'd255;

            #1;


            check_outputs(16'hFE01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large x^3 overflow", test_num);
            a0 = 0; a1 = 0; a2 = 0; a3 = 16'd1; x = 8'd255;


            #1;



            check_outputs(16'h02FF);
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
