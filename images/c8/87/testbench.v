`timescale 1ns/1ps

module calculator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in1;
    reg [3:0] in2;
    reg op;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    calculator dut (
        .in1(in1),
        .in2(in2),
        .op(op),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition - Basic (1 + 2)", test_num);
            in1 = 4'd1;
            in2 = 4'd2;
            op = 1'b0;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition - Zero Identity (5 + 0)", test_num);
            in1 = 4'd5;
            in2 = 4'd0;
            op = 1'b0;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition - Overflow (15 + 1)", test_num);
            in1 = 4'd15;
            in2 = 4'd1;
            op = 1'b0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition - Max Range (15 + 15)", test_num);
            in1 = 4'd15;
            in2 = 4'd15;
            op = 1'b0;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction - Basic (10 - 4)", test_num);
            in1 = 4'd10;
            in2 = 4'd4;
            op = 1'b1;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction - Result Zero (7 - 7)", test_num);
            in1 = 4'd7;
            in2 = 4'd7;
            op = 1'b1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction - Underflow/Wrap (2 - 5)", test_num);
            in1 = 4'd2;
            in2 = 4'd5;
            op = 1'b1;
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction - Underflow (0 - 1)", test_num);
            in1 = 4'd0;
            in2 = 4'd1;
            op = 1'b1;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition - Both Zero (0 + 0)", test_num);
            in1 = 4'd0;
            in2 = 4'd0;
            op = 1'b0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction - Max minus Zero (15 - 0)", test_num);
            in1 = 4'd15;
            in2 = 4'd0;
            op = 1'b1;
            #1;

            check_outputs(4'd15);
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
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
