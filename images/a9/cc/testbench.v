`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg add;
    reg sub;
    wire [7:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .add(add),
        .sub(sub),
        .Z(Z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple Addition (5 + 3)", test_num);
        A = 8'd5;
        B = 8'd3;
        add = 1'b1;
        sub = 1'b0;
        #1;

        check_outputs(8'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple Subtraction (10 - 4)", test_num);
        A = 8'd10;
        B = 8'd4;
        add = 1'b0;
        sub = 1'b1;
        #1;

        check_outputs(8'd6);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: No control signals active (Default to 0)", test_num);
        A = 8'd25;
        B = 8'd10;
        add = 1'b0;
        sub = 1'b0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition with Overflow (250 + 10)", test_num);
        A = 8'd250;
        B = 8'd10;
        add = 1'b1;
        sub = 1'b0;
        #1;

        check_outputs(8'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction with Underflow (5 - 10)", test_num);
        A = 8'd5;
        B = 8'd10;
        add = 1'b0;
        sub = 1'b1;
        #1;

        check_outputs(8'd251);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Adding Zeros", test_num);
        A = 8'd0;
        B = 8'd0;
        add = 1'b1;
        sub = 1'b0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max values addition (255 + 255)", test_num);
        A = 8'hFF;
        B = 8'hFF;
        add = 1'b1;
        sub = 1'b0;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction of same values (128 - 128)", test_num);
        A = 8'd128;
        B = 8'd128;
        add = 1'b0;
        sub = 1'b1;
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
        input [7:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
