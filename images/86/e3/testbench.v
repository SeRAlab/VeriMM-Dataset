`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg rst;
    reg [3:0] state;
    reg x;
    wire A_next;
    wire B_next;
    wire C_next;
    wire D_next;
    wire y;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rst(rst),
        .state(state),
        .x(x),
        .A_next(A_next),
        .B_next(B_next),
        .C_next(C_next),
        .D_next(D_next),
        .y(y),
        .z(z)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset logic (rst=1)", test_num);
        rst = 1;
        state = 4'b0010;
        x = 0;
        #10;

        #1;


        check_outputs(1, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: State A, x=0 (Transition to B)", test_num);
        rst = 1; #5; rst = 0;
        state = 4'b0001;
        x = 0;
        #10;

        #1;


        check_outputs(0, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: State A, x=1 (Transition to C)", test_num);
        rst = 1; #5; rst = 0;
        state = 4'b0001;
        x = 1;
        #10;

        #1;


        check_outputs(0, 0, 1, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: State B, x=0 (Transition to D)", test_num);
        rst = 1; #5; rst = 0;
        state = 4'b0010;
        x = 0;
        #10;

        #1;


        check_outputs(0, 0, 0, 1, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: State B, x=1 (Transition to A)", test_num);
        rst = 1; #5; rst = 0;
        state = 4'b0010;
        x = 1;
        #10;

        #1;


        check_outputs(1, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: State C, x=0 (Transition to C)", test_num);
        rst = 1; #5; rst = 0;
        state = 4'b0100;
        x = 0;
        #10;

        #1;


        check_outputs(0, 0, 1, 0, 1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: State C, x=1 (Transition to D)", test_num);
        rst = 1; #5; rst = 0;
        state = 4'b0100;
        x = 1;
        #10;

        #1;


        check_outputs(0, 0, 0, 1, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: State D, x=0 (Transition to A)", test_num);
        rst = 1; #5; rst = 0;
        state = 4'b1000;
        x = 0;
        #10;

        #1;


        check_outputs(1, 0, 0, 0, 0, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: State D, x=1 (Transition to B)", test_num);
        rst = 1; #5; rst = 0;
        state = 4'b1000;
        x = 1;
        #10;

        #1;


        check_outputs(0, 1, 0, 0, 0, 1);
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
        input expected_A_next;
        input expected_B_next;
        input expected_C_next;
        input expected_D_next;
        input expected_y;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_next === (expected_A_next ^ A_next ^ expected_A_next) &&
                expected_B_next === (expected_B_next ^ B_next ^ expected_B_next) &&
                expected_C_next === (expected_C_next ^ C_next ^ expected_C_next) &&
                expected_D_next === (expected_D_next ^ D_next ^ expected_D_next) &&
                expected_y === (expected_y ^ y ^ expected_y) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: A_next=%b, B_next=%b, C_next=%b, D_next=%b, y=%b, z=%b",
                         A_next, B_next, C_next, D_next, y, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_next=%b, B_next=%b, C_next=%b, D_next=%b, y=%b, z=%b",
                         expected_A_next, expected_B_next, expected_C_next, expected_D_next, expected_y, expected_z);
                $display("  Got:      A_next=%b, B_next=%b, C_next=%b, D_next=%b, y=%b, z=%b",
                         A_next, B_next, C_next, D_next, y, z);
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
