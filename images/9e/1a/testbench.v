`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] iv;
    reg [127:0] key;
    reg [1:0] mode_sel;
    reg [127:0] plaintext;
    wire [127:0] ciphertext;
    wire [127:0] hash_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iv(iv),
        .key(key),
        .mode_sel(mode_sel),
        .plaintext(plaintext),
        .ciphertext(ciphertext),
        .hash_value(hash_value)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mode 00 - AES Encryption", test_num);
        plaintext = 128'h6bc1bee22e409f96e93d7e117393172a;
        key       = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        iv        = 128'h000102030405060708090a0b0c0d0e0f;
        mode_sel  = 2'b00;


        #1;



        check_outputs(128'h7649abac8119b246cee98e9b12e9197d, 128'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mode 01 - AES Decryption", test_num);
        plaintext = 128'h7649abac8119b246cee98e9b12e9197d;
        key       = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        iv        = 128'h000102030405060708090a0b0c0d0e0f;
        mode_sel  = 2'b01;

        #1;


        check_outputs(128'h6bc1bee22e409f96e93d7e117393172a, 128'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mode 10 - SHA-256 Hashing", test_num);
        plaintext = 128'h48656c6c6f20576f726c642100000000;
        key       = 128'h0;
        iv        = 128'h0;
        mode_sel  = 2'b10;

        #1;


        check_outputs(128'h0, 128'hc38072d09c128c1173514a4630739198);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mode 11 - Invalid Selection (Expect Zero)", test_num);
        plaintext = 128'hffffffffffffffffffffffffffffffff;
        key       = 128'hffffffffffffffffffffffffffffffff;
        iv        = 128'hffffffffffffffffffffffffffffffff;
        mode_sel  = 2'b11;

        #1;


        check_outputs(128'h0, 128'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Case - All Zeroes Mode 00", test_num);
        plaintext = 128'h0;
        key       = 128'h0;
        iv        = 128'h0;
        mode_sel  = 2'b00;

        #1;


        check_outputs(128'h66e94bd4ef8a2c3b884cfa59ca342b2e, 128'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mode 11 - Invalid Selection Alternate Data", test_num);
        plaintext = 128'h123456789abcdef0123456789abcdef0;
        key       = 128'h0;
        iv        = 128'h0;
        mode_sel  = 2'b11;

        #1;


        check_outputs(128'h0, 128'h0);
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
        input [127:0] expected_ciphertext;
        input [127:0] expected_hash_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext) &&
                expected_hash_value === (expected_hash_value ^ hash_value ^ expected_hash_value)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h, hash_value=%h",
                         ciphertext, hash_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h, hash_value=%h",
                         expected_ciphertext, expected_hash_value);
                $display("  Got:      ciphertext=%h, hash_value=%h",
                         ciphertext, hash_value);
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
