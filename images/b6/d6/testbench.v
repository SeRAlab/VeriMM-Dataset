`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire chk;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .chk(chk),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        in = 8'b00000000;
        $display("Test %0d: Input 8'b00000000 (0 ones - Even)", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in = 8'b00000001;
        $display("Test %0d: Input 8'b00000001 (1 one - Odd)", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in = 8'b00000011;
        $display("Test %0d: Input 8'b00000011 (2 ones - Even)", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in = 8'b00000111;
        $display("Test %0d: Input 8'b00000111 (3 ones - Odd)", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in = 8'b00001111;
        $display("Test %0d: Input 8'b00001111 (4 ones - Even)", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in = 8'b00011111;
        $display("Test %0d: Input 8'b00011111 (5 ones - Odd)", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in = 8'b00111111;
        $display("Test %0d: Input 8'b00111111 (6 ones - Even)", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in = 8'b01111111;
        $display("Test %0d: Input 8'b01111111 (7 ones - Odd)", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in = 8'b11111111;
        $display("Test %0d: Input 8'b11111111 (8 ones - Even)", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in = 8'b10101010;
        $display("Test %0d: Input 8'b10101010 (4 ones - Even)", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
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
        input expected_chk;
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_chk === (expected_chk ^ chk ^ expected_chk) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: chk=%b, out=%b",
                         chk, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: chk=%b, out=%b",
                         expected_chk, expected_out);
                $display("  Got:      chk=%b, out=%b",
                         chk, out);
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
