`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] hex;
    wire [3:0] bcd;
    wire carry;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hex(hex),
        .bcd(bcd),
        .carry(carry)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input hex = 4'h0", test_num);
        hex = 4'h0;
        #1;

        check_outputs(4'h0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input hex = 4'h5", test_num);
        hex = 4'h5;
        #1;

        check_outputs(4'h5, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input hex = 4'h9 (Boundary)", test_num);
        hex = 4'h9;
        #1;

        check_outputs(4'h9, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input hex = 4'hA (Carry start)", test_num);
        hex = 4'hA;
        #1;

        check_outputs(4'h0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input hex = 4'hD", test_num);
        hex = 4'hD;
        #1;

        check_outputs(4'h3, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input hex = 4'hF (Max value)", test_num);
        hex = 4'hF;
        #1;

        check_outputs(4'h5, 1'b1);
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
        input [3:0] expected_bcd;
        input expected_carry;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd === (expected_bcd ^ bcd ^ expected_bcd) &&
                expected_carry === (expected_carry ^ carry ^ expected_carry)) begin
                $display("PASS");
                $display("  Outputs: bcd=%h, carry=%b",
                         bcd, carry);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd=%h, carry=%b",
                         expected_bcd, expected_carry);
                $display("  Got:      bcd=%h, carry=%b",
                         bcd, carry);
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
