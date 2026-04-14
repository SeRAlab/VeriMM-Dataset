`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data;
    reg [31:0] key;
    wire [31:0] encrypted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .key(key),
        .encrypted(encrypted)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        data = 32'h00000000;
        key  = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit Inversion (Key=All Fs)", test_num);
        data = 32'h12345678;
        key  = 32'hFFFFFFFF;
        #1;

        check_outputs(~32'h12345678);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Complementary Patterns", test_num);
        data = 32'hAAAAAAAA;
        key  = 32'h55555555;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Byte-chunk Verification", test_num);
        data = 32'hDEADBEEF;
        key  = 32'h11223344;
        #1;

        check_outputs(32'hCF8F8DAB);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Identity XOR", test_num);
        data = 32'hCAFEBABE;
        key  = 32'hCAFEBABE;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Complex Values", test_num);
        data = 32'h0F0F0F0F;
        key  = 32'hF0F0F0F0;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Bit Change", test_num);
        data = 32'h00000001;
        key  = 32'h80000000;
        #1;

        check_outputs(32'h80000001);
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
        input [31:0] expected_encrypted;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encrypted === (expected_encrypted ^ encrypted ^ expected_encrypted)) begin
                $display("PASS");
                $display("  Outputs: encrypted=%h",
                         encrypted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encrypted=%h",
                         expected_encrypted);
                $display("  Got:      encrypted=%h",
                         encrypted);
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
