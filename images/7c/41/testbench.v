`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] key;
    reg [31:0] msg;
    wire [31:0] ciphertext;
    wire [31:0] hash;
    wire [31:0] plaintext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .key(key),
        .msg(msg),
        .ciphertext(ciphertext),
        .hash(hash),
        .plaintext(plaintext)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: All Zeros", test_num);
            msg = 32'h00000000;
            key = 32'h00000000;
            #10;

            #1;


            check_outputs(32'h00000000, 32'hAAAAAAAA, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: All Ones", test_num);
            msg = 32'hFFFFFFFF;
            key = 32'hFFFFFFFF;
            #10;

            #1;


            check_outputs(32'h00000000, 32'h55555555, 32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Zero Key Identity", test_num);
            msg = 32'h12345678;
            key = 32'h00000000;
            #10;

            #1;


            check_outputs(32'h12345678, 32'hB89EFCD2, 32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Alternating Bit Patterns", test_num);
            msg = 32'hAAAAAAAA;
            key = 32'h55555555;
            #10;

            #1;


            check_outputs(32'hFFFFFFFF, 32'h00000000, 32'hAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Complex Data Check", test_num);
            msg = 32'hDEADBEEF;
            key = 32'h13579BDF;
            #10;

            #1;


            check_outputs(32'hCDFA2530, 32'h74071445, 32'hDEADBEEF);
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
        input [31:0] expected_ciphertext;
        input [31:0] expected_hash;
        input [31:0] expected_plaintext;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext) &&
                expected_hash === (expected_hash ^ hash ^ expected_hash) &&
                expected_plaintext === (expected_plaintext ^ plaintext ^ expected_plaintext)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h, hash=%h, plaintext=%h",
                         ciphertext, hash, plaintext);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h, hash=%h, plaintext=%h",
                         expected_ciphertext, expected_hash, expected_plaintext);
                $display("  Got:      ciphertext=%h, hash=%h, plaintext=%h",
                         ciphertext, hash, plaintext);
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
