`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg As_Sel;
    reg [3:0] x;
    reg [3:0] y;
    wire Cout;
    wire [3:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .As_Sel(As_Sel),
        .x(x),
        .y(y),
        .Cout(Cout),
        .s(s)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (5 + 3)", test_num);
        As_Sel = 0;
        x = 4'd5;
        y = 4'd3;
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (10 + 10)", test_num);
        As_Sel = 0;
        x = 4'd10;
        y = 4'd10;
        #1;

        check_outputs(1'b1, 4'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (15 + 15)", test_num);
        As_Sel = 0;
        x = 4'd15;
        y = 4'd15;
        #1;

        check_outputs(1'b1, 4'd14);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (0 + 0)", test_num);
        As_Sel = 0;
        x = 4'd0;
        y = 4'd0;
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (10 - 4)", test_num);
        As_Sel = 1;
        x = 4'd10;
        y = 4'd4;

        #1;


        check_outputs(1'b1, 4'd6);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (7 - 7)", test_num);
        As_Sel = 1;
        x = 4'd7;
        y = 4'd7;

        #1;


        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (2 - 5)", test_num);
        As_Sel = 1;
        x = 4'd2;
        y = 4'd5;

        #1;


        check_outputs(1'b0, 4'd13);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (0 - 1)", test_num);
        As_Sel = 1;
        x = 4'd0;
        y = 4'd1;

        #1;


        check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (15 - 0)", test_num);
        As_Sel = 1;
        x = 4'd15;
        y = 4'd0;

        #1;


        check_outputs(1'b1, 4'd15);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (8 + 8)", test_num);
        As_Sel = 0;
        x = 4'd8;
        y = 4'd8;

        #1;


        check_outputs(1'b1, 4'd0);
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
        input expected_Cout;
        input [3:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, s=%h",
                         Cout, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, s=%h",
                         expected_Cout, expected_s);
                $display("  Got:      Cout=%b, s=%h",
                         Cout, s);
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
