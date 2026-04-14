`timescale 1ns/1ps

module multi_io_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [3:0] in1;
    reg [2:0] in2;
    reg in3;
    wire [1:0] out1;
    wire out2;
    wire [2:0] out3;
    wire out4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multi_io_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            in1 = 4'd0;
            in2 = 3'd0;
            in3 = 1'b0;




            #1;





            check_outputs(2'd0, 1'b0, 3'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Values", test_num);
            in1 = 4'd1;
            in2 = 3'd1;
            in3 = 1'b0;




            #1;





            check_outputs(2'd2, 1'b1, 3'd1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Values and Truncation", test_num);
            in1 = 4'd15;
            in2 = 3'd7;
            in3 = 1'b1;




            #1;





            check_outputs(2'd2, 1'b0, 3'd7, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Logic Check 1", test_num);
            in1 = 4'b0101;
            in2 = 3'b010;
            in3 = 1'b1;




            #1;





            check_outputs(2'd3, 1'b0, 3'd2, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Logic Check 2", test_num);
            in1 = 4'b1010;
            in2 = 3'b101;
            in3 = 1'b0;




            #1;





            check_outputs(2'd3, 1'b0, 3'd5, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Logic", test_num);
            in1 = 4'b1000;
            in2 = 3'b100;
            in3 = 1'b1;




            #1;





            check_outputs(2'd0, 1'b1, 3'd4, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multi_io_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [1:0] expected_out1;
        input expected_out2;
        input [2:0] expected_out3;
        input expected_out4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3) &&
                expected_out4 === (expected_out4 ^ out4 ^ expected_out4)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%b, out3=%h, out4=%b",
                         out1, out2, out3, out4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%b, out3=%h, out4=%b",
                         expected_out1, expected_out2, expected_out3, expected_out4);
                $display("  Got:      out1=%h, out2=%b, out3=%h, out4=%b",
                         out1, out2, out3, out4);
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
