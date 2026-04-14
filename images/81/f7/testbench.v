`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] ciphertext;
    reg [127:0] key;
    reg [255:0] message;
    reg [255:0] plaintext;
    wire [255:0] ciphertext_out;
    wire [255:0] hash_out;
    wire [255:0] plaintext_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ciphertext(ciphertext),
        .key(key),
        .message(message),
        .plaintext(plaintext),
        .ciphertext_out(ciphertext_out),
        .hash_out(hash_out),
        .plaintext_out(plaintext_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            plaintext = 256'h0;
            key = 128'h0;
            ciphertext = 256'h0;
            message = 256'h0;





            #1;






            check_outputs(
                256'h0,
                256'hf5a5fd42d16a20302798ef6ed309979b43003d2320d9f0e8ea9831a92759fb4b,
                256'h0
            );
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones", test_num);
            plaintext = {256{1'b1}};
            key = {128{1'b1}};
            ciphertext = {256{1'b1}};
            message = {256{1'b1}};





            #1;






            check_outputs(
                256'h0,
                256'hef5428a2a07802b8d0023a103323f465a3d7070183ca64917951a8d9a40733a7,
                256'h0
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple XOR Patterns", test_num);
            plaintext = 256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            key = 128'h55555555555555555555555555555555;
            ciphertext = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            message = 256'h1234567812345678123456781234567812345678123456781234567812345678;





            #1;






            check_outputs(
                256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
                256'h720a969f6e6255743b67e88701968875505e6b7d602330f81d87e0401d670691,
                256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ECB Mode Verification", test_num);

            plaintext = 256'h00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            key = 128'h0123456789ABCDEF0123456789ABCDEF;
            ciphertext = 256'h0;
            message = 256'h0;




            #1;





            check_outputs(
                256'h0123456789ABCDEF0123456789ABCDEFFEDCBA9876543210FEDCBA9876543210,
                256'hf5a5fd42d16a20302798ef6ed309979b43003d2320d9f0e8ea9831a92759fb4b,
                256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF
            );
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random Data Consistency", test_num);
            plaintext = 256'hDEADBEEFCAFEBABE1234567887654321F00DBABECAFEDEAD8765432112345678;
            key = 128'hFEEDFACECAFEBEEF123456789ABCDEF0;
            ciphertext = 256'h0;
            message = 256'h4142430000000000000000000000000000000000000000000000000000000000;




            #1;





            check_outputs(
                256'h2045420100000451000000001DDA9CD10E03E440000060429551155988F88988,
                256'h783e74bc4863372f5d08705f15c7e1081e6a10741f0219808a38ec22849b291a,
                256'hFEEDFACECAFEBEEF123456789ABCDEF0FEEDFACECAFEBEEF123456789ABCDEF0
            );
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
        input [255:0] expected_ciphertext_out;
        input [255:0] expected_hash_out;
        input [255:0] expected_plaintext_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ciphertext_out === (expected_ciphertext_out ^ ciphertext_out ^ expected_ciphertext_out) &&
                expected_hash_out === (expected_hash_out ^ hash_out ^ expected_hash_out) &&
                expected_plaintext_out === (expected_plaintext_out ^ plaintext_out ^ expected_plaintext_out)) begin
                $display("PASS");
                $display("  Outputs: ciphertext_out=%h, hash_out=%h, plaintext_out=%h",
                         ciphertext_out, hash_out, plaintext_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext_out=%h, hash_out=%h, plaintext_out=%h",
                         expected_ciphertext_out, expected_hash_out, expected_plaintext_out);
                $display("  Got:      ciphertext_out=%h, hash_out=%h, plaintext_out=%h",
                         ciphertext_out, hash_out, plaintext_out);
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
