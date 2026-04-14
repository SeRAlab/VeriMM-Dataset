`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg operation;
    reg reset;
    wire [7:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .operation(operation),
        .reset(reset),
        .C(C)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset functionality (Output should be 0)", test_num);
        reset = 1'b1;
        A = 8'd10;
        B = 8'd20;
        operation = 1'b0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Addition (15 + 25)", test_num);
        reset = 1'b1; #5; reset = 1'b0;
        A = 8'd15;
        B = 8'd25;
        operation = 1'b0;
        #1;

        check_outputs(8'd40);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Subtraction (100 - 40)", test_num);
        reset = 1'b1; #5; reset = 1'b0;
        A = 8'd100;
        B = 8'd40;
        operation = 1'b1;
        #1;

        check_outputs(8'd60);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition with Overflow (250 + 10)", test_num);
        reset = 1'b1; #5; reset = 1'b0;
        A = 8'd250;
        B = 8'd10;
        operation = 1'b0;
        #1;

        check_outputs(8'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction with Underflow (10 - 20)", test_num);
        reset = 1'b1; #5; reset = 1'b0;
        A = 8'd10;
        B = 8'd20;
        operation = 1'b1;
        #1;

        check_outputs(8'd246);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum values Subtraction (255 - 255)", test_num);
        reset = 1'b1; #5; reset = 1'b0;
        A = 8'hFF;
        B = 8'hFF;
        operation = 1'b1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Checking operation logic swap (50 - 100)", test_num);
        reset = 1'b1; #5; reset = 1'b0;
        A = 8'd50;
        B = 8'd100;
        operation = 1'b1;
        #1;

        check_outputs(8'd206);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset overriding subtraction mid-simulation", test_num);
        reset = 1'b0;
        A = 8'd200;
        B = 8'd50;
        operation = 1'b1;
        #2;
        reset = 1'b1;
        #1;

        check_outputs(8'd0);
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
        input [7:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
