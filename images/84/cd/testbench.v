`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] key;
    reg [127:0] word;
    wire [127:0] str;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .key(key),
        .word(word),
        .str(str)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            word = 128'h0;
            key = 128'h0;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Word with Zero Key", test_num);
            word = 128'h6bc1bee22e409f96e93d7e117393172a;
            key  = 128'h0;
            #1;

            check_outputs(128'h6bc1bee22e409f96e93d7e117393172a);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: All F's XOR All F's", test_num);
            word = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            key  = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Checkerboard Pattern", test_num);
            word = 128'h55555555555555555555555555555555;
            key  = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            #1;

            check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: NIST Standard AES Vector (Example Round)", test_num);

            word = 128'h00112233445566778899aabbccddeeff;
            key  = 128'h000102030405060708090a0b0c0d0e0f;
            #1;

            check_outputs(128'h00102030405060708090a0b0c0d0e0f0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Random Key and Word", test_num);
            word = 128'h2b7e151628aed2a6abf7158809cf4f3c;
            key  = 128'ha0fafe1788542cb1fe2c39006332c597;

            #1;


            check_outputs(128'h8b84eb01a0fad61755db2c886aff8aaf);
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
        input [127:0] expected_str;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_str === (expected_str ^ str ^ expected_str)) begin
                $display("PASS");
                $display("  Outputs: str=%h",
                         str);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: str=%h",
                         expected_str);
                $display("  Got:      str=%h",
                         str);
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
