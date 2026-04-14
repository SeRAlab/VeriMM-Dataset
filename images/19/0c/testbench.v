`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] w1;
    reg [31:0] w2;
    reg [31:0] w3;
    reg [31:0] w4;
    reg [31:0] w5;
    reg [31:0] x1;
    reg [31:0] x2;
    reg [31:0] x3;
    reg [31:0] x4;
    reg [31:0] x5;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .w1(w1),
        .w2(w2),
        .w3(w3),
        .w4(w4),
        .w5(w5),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .x5(x5),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            w1 = 32'd0; w2 = 32'd0; w3 = 32'd0; w4 = 32'd0; w5 = 32'd0;
            x1 = 32'd0; x2 = 32'd0; x3 = 32'd0; x4 = 32'd0; x5 = 32'd0;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            w1 = 32'd1; w2 = 32'd1; w3 = 32'd1; w4 = 32'd1; w5 = 32'd1;
            x1 = 32'd1; x2 = 32'd1; x3 = 32'd1; x4 = 32'd1; x5 = 32'd1;
            #1;

            check_outputs(32'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Weights and Inputs scale", test_num);
            w1 = 32'd1; w2 = 32'd2; w3 = 32'd3; w4 = 32'd4; w5 = 32'd5;
            x1 = 32'd10; x2 = 32'd20; x3 = 32'd30; x4 = 32'd40; x5 = 32'd50;

            #1;


            check_outputs(32'd550);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only one active input", test_num);
            w1 = 32'd0; w2 = 32'd100; w3 = 32'd0; w4 = 32'd0; w5 = 32'd0;
            x1 = 32'd50; x2 = 32'd5; x3 = 32'd20; x4 = 32'd10; x5 = 32'd5;

            #1;


            check_outputs(32'd500);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative weights (Signed)", test_num);
            w1 = -32'd1; w2 = 32'd5; w3 = -32'd2; w4 = 32'd10; w5 = 32'd0;
            x1 = 32'd10; x2 = 32'd2; x3 = 32'd5; x4 = 32'd1; x5 = 32'd100;

            #1;


            check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large result within 32-bit", test_num);
            w1 = 32'd10000; w2 = 32'd20000; w3 = 32'd30000; w4 = 32'd40000; w5 = 32'd50000;
            x1 = 32'd10; x2 = 32'd10; x3 = 32'd10; x4 = 32'd10; x5 = 32'd10;

            #1;


            check_outputs(32'd1500000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed values", test_num);
            w1 = 32'd123; w2 = -32'd45; w3 = 32'd67; w4 = -32'd89; w5 = 32'd12;
            x1 = 32'd10; x2 = 32'd5; x3 = 32'd8; x4 = 32'd2; x5 = 32'd20;


            #1;



            check_outputs(32'd1603);
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
        input [31:0] expected_result;
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
