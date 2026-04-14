`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [2:0] op;
    wire [15:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .res(res)
    );
    task testcase001;

    begin
        test_num = test_num + 1;

        a = 8'd0; b = 8'd0; op = 3'b000;
        #5;

        a = 8'd15; b = 8'd25; op = 3'b000;
        #5;
        $display("Testcase %0d: Addition (15 + 25)", test_num);
        #1;

        check_outputs(16'd40);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        a = 8'd0; b = 8'd0; op = 3'b000;
        #5;

        a = 8'd255; b = 8'd255; op = 3'b000;
        #5;
        $display("Testcase %0d: Addition Max (255 + 255)", test_num);
        #1;

        check_outputs(16'd510);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        a = 8'd0; b = 8'd0; op = 3'b000;
        #5;

        a = 8'd100; b = 8'd35; op = 3'b001;
        #5;
        $display("Testcase %0d: Subtraction (100 - 35)", test_num);
        #1;

        check_outputs(16'd65);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        a = 8'd0; b = 8'd0; op = 3'b000;
        #5;

        a = 8'd10; b = 8'd20; op = 3'b001;
        #5;
        $display("Testcase %0d: Subtraction Negative (10 - 20)", test_num);
        #1;

        check_outputs(16'hFFF6);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        a = 8'd0; b = 8'd0; op = 3'b000;
        #5;

        a = 8'd12; b = 8'd10; op = 3'b010;
        #5;
        $display("Testcase %0d: Multiplication (12 * 10)", test_num);
        #1;

        check_outputs(16'd120);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        a = 8'd0; b = 8'd0; op = 3'b000;
        #5;

        a = 8'd255; b = 8'd255; op = 3'b010;
        #5;
        $display("Testcase %0d: Multiplication Max (255 * 255)", test_num);
        #1;

        check_outputs(16'd65025);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        a = 8'd0; b = 8'd0; op = 3'b000;
        #5;

        a = 8'd100; b = 8'd4; op = 3'b011;
        #5;
        $display("Testcase %0d: Division (100 / 4)", test_num);
        #1;

        check_outputs(16'd25);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        a = 8'd0; b = 8'd0; op = 3'b000;
        #5;

        a = 8'd10; b = 8'd3; op = 3'b011;
        #5;
        $display("Testcase %0d: Division Truncation (10 / 3)", test_num);
        #1;

        check_outputs(16'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        a = 8'd0; b = 8'd0; op = 3'b000;
        #5;

        a = 8'd50; b = 8'd50; op = 3'b101;
        #5;
        $display("Testcase %0d: Invalid Op Code (5)", test_num);
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        a = 8'd0; b = 8'd0; op = 3'b000;
        #5;

        a = 8'd255; b = 8'd0; op = 3'b010;
        #5;
        $display("Testcase %0d: Multiply by Zero", test_num);
        #1;

        check_outputs(16'd0);
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
        input [15:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
