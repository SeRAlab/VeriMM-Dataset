`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] hmac;
    reg [255:0] key;
    reg [255:0] message;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hmac(hmac),
        .key(key),
        .message(message),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Valid HMAC (Standard inputs)", test_num);
            key     = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            message = 256'h0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20;
            hmac    = 256'h6f9c940685741639d48b79b8829d2019b33a593740286821217730e1374945e5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Valid HMAC (Zeroed inputs)", test_num);
            key     = 256'h0;
            message = 256'h0;
            hmac    = 256'hb613679a0814d9ec772f95d778c309129733a28addd200706424724067347a40;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Valid HMAC (All-ones inputs)", test_num);
            key     = {256{1'b1}};
            message = {256{1'b1}};
            hmac    = 256'he254751494943714b16259020473e34a6258f121b6d02846f4995476a6b87617;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Invalid HMAC (Wrong HMAC tag)", test_num);
            key     = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            message = 256'h0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20;
            hmac    = 256'hdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Invalid HMAC (Message bit-flip)", test_num);
            key     = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            message = 256'h0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f21;
            hmac    = 256'h6f9c940685741639d48b79b8829d2019b33a593740286821217730e1374945e5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Invalid HMAC (Key bit-flip)", test_num);
            key     = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1e;
            message = 256'h0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20;
            hmac    = 256'h6f9c940685741639d48b79b8829d2019b33a593740286821217730e1374945e5;
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
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: valid=%b",
                         valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid=%b",
                         expected_valid);
                $display("  Got:      valid=%b",
                         valid);
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
