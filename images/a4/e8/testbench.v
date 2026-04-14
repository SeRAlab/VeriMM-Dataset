`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg M;
    reg [3:0] a;
    reg [3:0] b;
    reg ci;
    reg [3:0] s;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .M(M),
        .a(a),
        .b(b),
        .ci(ci),
        .s(s),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logic Mode - Operation S=0000 (Expected: ~A)", test_num);
            M = 1; s = 4'b0000; a = 4'b1010; b = 4'b0101; ci = 0;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logic Mode - Operation S=1111 (Expected: A)", test_num);
            M = 1; s = 4'b1111; a = 4'b1100; b = 4'b0011; ci = 0;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logic Mode - Operation S=1010 (Expected: B)", test_num);
            M = 1; s = 4'b1010; a = 4'b1100; b = 4'b0111; ci = 0;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arithmetic Mode - Addition (Expected: A + B)", test_num);
            M = 0; s = 4'b1001; a = 4'b0011; b = 4'b0100; ci = 0;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arithmetic Mode - Addition with Carry (Expected: A + B + 1)", test_num);
            M = 0; s = 4'b1001; a = 4'b0011; b = 4'b0100; ci = 1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arithmetic Mode - Subtraction (Expected: A - B)", test_num);
            M = 0; s = 4'b0110; a = 4'b1000; b = 4'b0011; ci = 1;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logic Mode - Operation S=0110 (Expected: A ^ B)", test_num);
            M = 1; s = 4'b0110; a = 4'b1100; b = 4'b1010; ci = 0;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arithmetic Mode - Increment (Expected: A + 1)", test_num);
            M = 0; s = 4'b0000; a = 4'b1110; b = 4'b0000; ci = 1;
            #1;

            check_outputs(4'b1111);
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
        input [3:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
