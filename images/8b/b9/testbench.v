`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [1:0] Op;
    wire [31:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Op(Op),
        .C(C)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Addition (Op=00) - Basic", test_num);
        A = 32'd100;
        B = 32'd250;
        Op = 2'b00;
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Addition (Op=00) - Overflow", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        Op = 2'b00;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Subtraction (Op=01) - Basic", test_num);
        A = 32'd500;
        B = 32'd150;
        Op = 2'b01;
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Subtraction (Op=01) - Wrap around", test_num);
        A = 32'd10;
        B = 32'd20;
        Op = 2'b01;
        #1;

        check_outputs(32'hFFFFFFF6);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Multiplication (Op=10) - Basic", test_num);
        A = 32'd12;
        B = 32'd11;
        Op = 2'b10;
        #1;

        check_outputs(32'd132);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Multiplication (Op=10) - 32-bit Truncation", test_num);
        A = 32'h00010000;
        B = 32'h00010000;
        Op = 2'b10;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Division (Op=11) - Basic", test_num);
        A = 32'd100;
        B = 32'd10;
        Op = 2'b11;
        #1;

        check_outputs(32'd10);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Division (Op=11) - Integer division", test_num);
        A = 32'd7;
        B = 32'd2;
        Op = 2'b11;
        #1;

        check_outputs(32'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTestcase %0d: Division (Op=11) - Divide by Zero", test_num);
        A = 32'd50;
        B = 32'd0;
        Op = 2'b11;


        #1;



        check_outputs(32'd0);
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
        testcase009();
        
        
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
        input [31:0] expected_C;
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
