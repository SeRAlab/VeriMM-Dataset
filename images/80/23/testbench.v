`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg oe;
    reg [1:0] op;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .oe(oe),
        .op(op),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition (15 + 25)", test_num);
        A = 8'd15; B = 8'd25; op = 2'b00; oe = 1'b1;
        #1;

        check_outputs(8'd40);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition Overflow (200 + 100)", test_num);
        A = 8'd200; B = 8'd100; op = 2'b00; oe = 1'b1;
        #1;

        check_outputs(8'd44);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction (100 - 30)", test_num);
        A = 8'd100; B = 8'd30; op = 2'b01; oe = 1'b1;
        #1;

        check_outputs(8'd70);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction Underflow (10 - 20)", test_num);
        A = 8'd10; B = 8'd20; op = 2'b01; oe = 1'b1;
        #1;

        check_outputs(8'd246);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication High Byte (255 * 2)", test_num);
        A = 8'hFF; B = 8'h02; op = 2'b10; oe = 1'b1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication High Byte (255 * 255)", test_num);
        A = 8'hFF; B = 8'hFF; op = 2'b10; oe = 1'b1;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Division (100 / 4)", test_num);
        A = 8'd100; B = 8'd4; op = 2'b11; oe = 1'b1;
        #1;

        check_outputs(8'd25);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Division by Zero (100 / 0)", test_num);
        A = 8'd100; B = 8'd0; op = 2'b11; oe = 1'b1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Output Enable Check (oe=0)", test_num);
        A = 8'd10; B = 8'd10; op = 2'b00; oe = 1'b0;
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
        input [7:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
