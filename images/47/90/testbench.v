`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] in_word;
    wire [5:0] bits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_word(in_word),
        .bits(bits)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All bits zero", test_num);
        in_word = 64'h0000000000000000;
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single bit set (LSB)", test_num);
        in_word = 64'h0000000000000001;
        #1;

        check_outputs(6'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single bit set (MSB)", test_num);
        in_word = 64'h8000000000000000;
        #1;

        check_outputs(6'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits (0xAAAA...)", test_num);
        in_word = 64'hAAAAAAAAAAAAAAAA;
        #1;

        check_outputs(6'd32);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits (0x5555...)", test_num);
        in_word = 64'h5555555555555555;
        #1;

        check_outputs(6'd32);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 63 bits set (All but LSB)", test_num);
        in_word = 64'hFFFFFFFFFFFFFFFE;
        #1;

        check_outputs(6'd63);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All 64 bits set (Checks 6-bit overflow)", test_num);
        in_word = 64'hFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hex pattern 0xFEDCBA9876543210", test_num);
        in_word = 64'hFEDCBA9876543210;
        #1;

        check_outputs(6'd32);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Lower 16 bits set", test_num);
        in_word = 64'h000000000000FFFF;
        #1;

        check_outputs(6'd16);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 7 bits set", test_num);
        in_word = 64'h000000000000007F;
        #1;

        check_outputs(6'd7);
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
        input [5:0] expected_bits;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bits === (expected_bits ^ bits ^ expected_bits)) begin
                $display("PASS");
                $display("  Outputs: bits=%h",
                         bits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bits=%h",
                         expected_bits);
                $display("  Got:      bits=%h",
                         bits);
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
