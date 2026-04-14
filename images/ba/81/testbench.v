`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] op_code;
    wire is_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op_code(op_code),
        .is_valid(is_valid)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Testing op_code 0000 (Valid)", test_num);
        op_code = 4'b0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Testing op_code 0001 (Valid)", test_num);
        op_code = 4'b0001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Testing op_code 0010 (Valid)", test_num);
        op_code = 4'b0010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Testing op_code 0011 (Valid)", test_num);
        op_code = 4'b0011;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Testing op_code 0100 (Invalid - Forbidden)", test_num);
        op_code = 4'b0100;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Testing op_code 0101 (Valid)", test_num);
        op_code = 4'b0101;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Testing op_code 0110 (Invalid - Bits 1 & 2 set)", test_num);
        op_code = 4'b0110;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Testing op_code 0111 (Invalid - Bits 1 & 2 set)", test_num);
        op_code = 4'b0111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Testing op_code 1000 (Valid)", test_num);
        op_code = 4'b1000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Testing op_code 1011 (Invalid - Forbidden)", test_num);
        op_code = 4'b1011;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Testing op_code 1100 (Valid)", test_num);
        op_code = 4'b1100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: Testing op_code 1110 (Invalid - Bits 1 & 2 set)", test_num);
        op_code = 4'b1110;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Testcase %0d: Testing op_code 1111 (Invalid - Bits 1 & 2 set)", test_num);
        op_code = 4'b1111;
        #1;

        check_outputs(1'b0);
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
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input expected_is_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_valid === (expected_is_valid ^ is_valid ^ expected_is_valid)) begin
                $display("PASS");
                $display("  Outputs: is_valid=%b",
                         is_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_valid=%b",
                         expected_is_valid);
                $display("  Got:      is_valid=%b",
                         is_valid);
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
