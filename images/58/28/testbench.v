`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] data_in;
    wire multi_bit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .multi_bit(multi_bit)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Zero bits set", test_num);
        data_in = 64'h0000000000000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Exactly one bit set (LSB)", test_num);
        data_in = 64'h0000000000000001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Exactly one bit set (MSB)", test_num);
        data_in = 64'h8000000000000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Exactly one bit set (Bit 31)", test_num);
        data_in = 64'h0000000100000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Exactly two bits set (Adjacent)", test_num);
        data_in = 64'h0000000000000003;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Exactly two bits set (LSB and MSB)", test_num);
        data_in = 64'h8000000000000001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Multiple bits set (Random pattern)", test_num);
        data_in = 64'hA5A5A5A5A5A5A5A5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: All bits set", test_num);
        data_in = 64'hFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Three bits set", test_num);
        data_in = 64'h000000000000000E;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: One bit set (Bit 15)", test_num);
        data_in = (64'h1 << 15);
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
        input expected_multi_bit;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_multi_bit === (expected_multi_bit ^ multi_bit ^ expected_multi_bit)) begin
                $display("PASS");
                $display("  Outputs: multi_bit=%b",
                         multi_bit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: multi_bit=%b",
                         expected_multi_bit);
                $display("  Got:      multi_bit=%b",
                         multi_bit);
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
