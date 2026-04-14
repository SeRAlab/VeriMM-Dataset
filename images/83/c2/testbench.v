`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire error;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .error(error),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Inputs (0+0)^2", test_num);
            a = 4'd0;
            b = 4'd0;

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Sum (2+3)^2", test_num);
            a = 4'd2;
            b = 4'd3;

            #1;


            check_outputs(1'b0, 8'h19);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum No-Overflow (10+5)^2", test_num);
            a = 4'd10;
            b = 4'd5;

            #1;


            check_outputs(1'b0, 8'hE1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum Overflow (8+8)^2", test_num);
            a = 4'd8;
            b = 4'd8;


            #1;



            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range Overflow (12+12)^2", test_num);
            a = 4'd12;
            b = 4'd12;


            #1;



            check_outputs(1'b1, 8'h40);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Possible Overflow (15+15)^2", test_num);
            a = 4'd15;
            b = 4'd15;


            #1;



            check_outputs(1'b1, 8'h84);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Odd Sum Overflow (10+10)^2", test_num);
            a = 4'd10;
            b = 4'd10;


            #1;



            check_outputs(1'b1, 8'h90);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_error;
        input [7:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: error=%b, y=%h",
                         error, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, y=%h",
                         expected_error, expected_y);
                $display("  Got:      error=%b, y=%h",
                         error, y);
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
