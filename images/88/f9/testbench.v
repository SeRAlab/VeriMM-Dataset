`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input_a;
    reg [7:0] input_b;
    reg reset;
    wire [8:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_a(input_a),
        .input_b(input_b),
        .reset(reset),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        reset = 1;
        input_a = 8'sd25;
        input_b = 8'sd30;
        #10;
        #1;

        check_outputs(9'sd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset = 1; #5;
        reset = 0;
        input_a = 8'sd10;
        input_b = 8'sd20;
        #10;
        #1;

        check_outputs(9'sd30);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset = 1; #5;
        reset = 0;
        input_a = -8'sd15;
        input_b = -8'sd25;
        #10;
        #1;

        check_outputs(-9'sd40);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset = 1; #5;
        reset = 0;
        input_a = 8'sd50;
        input_b = -8'sd20;
        #10;
        #1;

        check_outputs(9'sd30);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset = 1; #5;
        reset = 0;
        input_a = -8'sd100;
        input_b = 8'sd40;
        #10;
        #1;

        check_outputs(-9'sd60);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset = 1; #5;
        reset = 0;
        input_a = 8'sd127;
        input_b = 8'sd127;
        #10;
        #1;

        check_outputs(9'sd254);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset = 1; #5;
        reset = 0;
        input_a = -8'sd128;
        input_b = -8'sd128;
        #10;
        #1;

        check_outputs(-9'sd256);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset = 1; #5;
        reset = 0;
        input_a = 8'sd75;
        input_b = -8'sd75;
        #10;
        #1;

        check_outputs(9'sd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        reset = 1; #5;
        reset = 0;
        input_a = -8'sd128;
        input_b = 8'sd127;
        #10;
        #1;

        check_outputs(-9'sd1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        reset = 1; #5;
        reset = 0;
        input_a = 8'sd0;
        input_b = 8'sd0;
        #10;
        #1;

        check_outputs(9'sd0);
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
        input [8:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
