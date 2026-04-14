`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_binary;
    reg [3:0] in_gray;
    wire [3:0] out_binary;
    wire [3:0] out_gray;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_binary(in_binary),
        .in_gray(in_gray),
        .out_binary(out_binary),
        .out_gray(out_gray)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros", test_num);
        in_binary = 4'b0000;
        in_gray = 4'b0000;
        #1;

        check_outputs(4'b0000, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: LSB Only", test_num);
        in_binary = 4'b0001;
        in_gray = 4'b0001;
        #1;

        check_outputs(4'b0001, 4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Power of 2 (Val 2)", test_num);
        in_binary = 4'b0010;
        in_gray = 4'b0011;
        #1;

        check_outputs(4'b0010, 4'b0011);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: MSB Transition (Val 8)", test_num);
        in_binary = 4'b1000;
        in_gray = 4'b1100;
        #1;

        check_outputs(4'b1000, 4'b1100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Values", test_num);
        in_binary = 4'b1111;
        in_gray = 4'b1000;
        #1;

        check_outputs(4'b1111, 4'b1000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mixed Pattern A", test_num);
        in_binary = 4'b0101;
        in_gray = 4'b0110;


        #1;



        check_outputs(4'b0100, 4'b0111);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mixed Pattern B", test_num);
        in_binary = 4'b1010;
        in_gray = 4'b1111;


        #1;



        check_outputs(4'b1010, 4'b1111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Symmetry Check", test_num);
        in_binary = 4'b0111;
        in_gray = 4'b0100;


        #1;



        check_outputs(4'b0111, 4'b0100);
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
        input [3:0] expected_out_binary;
        input [3:0] expected_out_gray;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_binary === (expected_out_binary ^ out_binary ^ expected_out_binary) &&
                expected_out_gray === (expected_out_gray ^ out_gray ^ expected_out_gray)) begin
                $display("PASS");
                $display("  Outputs: out_binary=%h, out_gray=%h",
                         out_binary, out_gray);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_binary=%h, out_gray=%h",
                         expected_out_binary, expected_out_gray);
                $display("  Got:      out_binary=%h, out_gray=%h",
                         out_binary, out_gray);
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
