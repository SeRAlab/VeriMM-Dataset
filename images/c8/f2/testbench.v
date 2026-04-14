`timescale 1ns/1ps

module calculator_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg op;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    calculator dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition (Positive + Positive)", test_num);
            a = 32'd100;
            b = 32'd250;
            op = 1'b0;
            #1;

            check_outputs(32'd350);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition (Negative + Negative)", test_num);
            a = -32'd50;
            b = -32'd75;
            op = 1'b0;
            #1;

            check_outputs(-32'd125);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition (Positive + Negative)", test_num);
            a = 32'd100;
            b = -32'd40;
            op = 1'b0;
            #1;

            check_outputs(32'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Subtraction (Positive - Positive)", test_num);
            a = 32'd500;
            b = 32'd200;
            op = 1'b1;
            #1;

            check_outputs(32'd300);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Subtraction (Negative - Negative)", test_num);
            a = -32'd100;
            b = -32'd30;
            op = 1'b1;
            #1;

            check_outputs(-32'd70);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Subtraction (Positive - Negative)", test_num);
            a = 32'd100;
            b = -32'd50;
            op = 1'b1;
            #1;

            check_outputs(32'd150);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary - Zero results", test_num);
            a = 32'd1234;
            b = 32'd1234;
            op = 1'b1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary - Max Positive Signed Int", test_num);
            a = 32'sh7FFFFFFF;
            b = 32'd0;
            op = 1'b0;
            #1;

            check_outputs(32'sh7FFFFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary - Min Negative Signed Int", test_num);
            a = 32'sh80000000;
            b = 32'd0;
            op = 1'b1;
            #1;

            check_outputs(32'sh80000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Signed Overflow/Wrap (Max + 1)", test_num);
            a = 32'sh7FFFFFFF;
            b = 32'd1;
            op = 1'b0;
            #1;

            check_outputs(32'sh80000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("calculator Testbench");
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
