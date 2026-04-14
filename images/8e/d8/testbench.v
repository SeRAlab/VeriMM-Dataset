`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] optr;
    wire [31:0] ret;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .optr(optr),
        .ret(ret),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (10 + 20)", test_num);
            A = 32'd10;
            B = 32'd20;
            optr = 3'b000;
            #1;

            check_outputs(32'd30, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (50 - 15)", test_num);
            A = 32'd50;
            B = 32'd15;
            optr = 3'b001;
            #1;

            check_outputs(32'd35, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Zero Check (100 - 100)", test_num);
            A = 32'd100;
            B = 32'd100;
            optr = 3'b001;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND", test_num);
            A = 32'hF0F0F0F0;
            B = 32'hFFFF0000;
            optr = 3'b010;
            #1;

            check_outputs(32'hF0F00000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise OR", test_num);
            A = 32'hAAAA5555;
            B = 32'h0000FFFF;
            optr = 3'b011;
            #1;

            check_outputs(32'hAAAAFFFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise XOR", test_num);
            A = 32'h12345678;
            B = 32'h12345678;
            optr = 3'b100;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Overflow Check", test_num);
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            optr = 3'b000;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (Small - Large)", test_num);
            A = 32'd0;
            B = 32'd1;
            optr = 3'b001;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
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
        input [31:0] expected_ret;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ret === (expected_ret ^ ret ^ expected_ret) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: ret=%h, zero=%b",
                         ret, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ret=%h, zero=%b",
                         expected_ret, expected_zero);
                $display("  Got:      ret=%h, zero=%b",
                         ret, zero);
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
