`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_vector;
    wire o0;
    wire o1;
    wire o2;
    wire o3;
    wire [3:0] out_vector;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_vector(in_vector),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .o3(o3),
        .out_vector(out_vector)
    );
    task testcase001;

        begin
            test_num = 1;
            in_vector = 4'b0000;
            $display("Testcase %0d: Testing in_vector = %b", test_num, in_vector);
            #1;

            check_outputs(0, 0, 0, 0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in_vector = 4'b1111;
            $display("Testcase %0d: Testing in_vector = %b", test_num, in_vector);
            #1;

            check_outputs(1, 1, 1, 1, 4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in_vector = 4'b1010;
            $display("Testcase %0d: Testing in_vector = %b", test_num, in_vector);
            #1;

            check_outputs(0, 1, 0, 1, 4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in_vector = 4'b0101;
            $display("Testcase %0d: Testing in_vector = %b", test_num, in_vector);
            #1;

            check_outputs(1, 0, 1, 0, 4'b0101);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in_vector = 4'b1000;
            $display("Testcase %0d: Testing in_vector = %b (Walking bit 3)", test_num, in_vector);
            #1;

            check_outputs(0, 0, 0, 1, 4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in_vector = 4'b0100;
            $display("Testcase %0d: Testing in_vector = %b (Walking bit 2)", test_num, in_vector);
            #1;

            check_outputs(0, 0, 1, 0, 4'b0100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in_vector = 4'b0010;
            $display("Testcase %0d: Testing in_vector = %b (Walking bit 1)", test_num, in_vector);
            #1;

            check_outputs(0, 1, 0, 0, 4'b0010);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in_vector = 4'b0001;
            $display("Testcase %0d: Testing in_vector = %b (Walking bit 0)", test_num, in_vector);
            #1;

            check_outputs(1, 0, 0, 0, 4'b0001);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in_vector = 4'b1100;
            $display("Testcase %0d: Testing in_vector = %b", test_num, in_vector);
            #1;

            check_outputs(0, 0, 1, 1, 4'b1100);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in_vector = 4'b0011;
            $display("Testcase %0d: Testing in_vector = %b", test_num, in_vector);
            #1;

            check_outputs(1, 1, 0, 0, 4'b0011);
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
        input expected_o0;
        input expected_o1;
        input expected_o2;
        input expected_o3;
        input [3:0] expected_out_vector;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_o3 === (expected_o3 ^ o3 ^ expected_o3) &&
                expected_out_vector === (expected_out_vector ^ out_vector ^ expected_out_vector)) begin
                $display("PASS");
                $display("  Outputs: o0=%b, o1=%b, o2=%b, o3=%b, out_vector=%h",
                         o0, o1, o2, o3, out_vector);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%b, o1=%b, o2=%b, o3=%b, out_vector=%h",
                         expected_o0, expected_o1, expected_o2, expected_o3, expected_out_vector);
                $display("  Got:      o0=%b, o1=%b, o2=%b, o3=%b, out_vector=%h",
                         o0, o1, o2, o3, out_vector);
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
