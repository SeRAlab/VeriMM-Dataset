`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] cla_bits;
    reg [3:0] ha_sum;
    wire [4:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cla_bits(cla_bits),
        .ha_sum(ha_sum),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        ha_sum = 4'b0000;
        cla_bits = 5'b00000;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ha_sum = 4'b1111;
        cla_bits = 5'b00000;
        #1;

        check_outputs(5'b01111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ha_sum = 4'b0000;
        cla_bits = 5'b11111;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ha_sum = 4'b1111;
        cla_bits = 5'b11111;
        #1;

        check_outputs(5'b10000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ha_sum = 4'b1010;
        cla_bits = 5'b01010;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ha_sum = 4'b0101;
        cla_bits = 5'b10101;
        #1;

        check_outputs(5'b10000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        ha_sum = 4'b1001;
        cla_bits = 5'b11001;
        #1;

        check_outputs(5'b10000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        ha_sum = 4'b0110;
        cla_bits = 5'b10110;
        #1;

        check_outputs(5'b10000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        ha_sum = 4'b1100;
        cla_bits = 5'b10011;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        ha_sum = 4'b0011;
        cla_bits = 5'b11100;
        #1;

        check_outputs(5'b11111);
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
        input [4:0] expected_sum;
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
