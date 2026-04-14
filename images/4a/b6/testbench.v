`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] data;
    reg [127:0] key;
    reg mode;
    wire [63:0] decrypted_data;
    wire [63:0] encrypted_data;
    wire [255:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .key(key),
        .mode(mode),
        .decrypted_data(decrypted_data),
        .encrypted_data(encrypted_data),
        .hash(hash)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Encryption Mode - All Zeros", test_num);
            mode = 1'b1;
            key  = 128'h0;
            data = 64'h0;

            #1;


            check_outputs(64'h0, 64'h0, 256'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Decryption/Hash Mode - All Zeros", test_num);
            mode = 1'b0;
            key  = 128'h0;
            data = 64'h0;
            #1;

            check_outputs(64'h0, 64'h0, 256'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Encryption Mode - All Ones", test_num);
            mode = 1'b1;
            key  = {128{1'b1}};
            data = {64{1'b1}};
            #1;

            check_outputs(64'h0, 64'hFFFFFFFFFFFFFFFF, 256'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Decryption/Hash Mode - All Ones", test_num);
            mode = 1'b0;
            key  = {128{1'b1}};
            data = {64{1'b1}};
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF, 64'h0, 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Encryption Mode - Alternating Pattern", test_num);
            mode = 1'b1;
            key  = 128'h5555555555555555AAAAAAAAAAAAAAAA;
            data = 64'hA5A5A5A5A5A5A5A5;
            #1;

            check_outputs(64'h0, 64'hA5A5A5A5A5A5A5A5, 256'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Decryption/Hash Mode - Unique Data", test_num);
            mode = 1'b0;
            key  = 128'hDEADBEEFCAFEBABE0123456789ABCDEF;
            data = 64'h1337C0DECAFEF00D;
            #1;

            check_outputs(64'h1337C0DECAFEF00D, 64'h0, 256'hDEADBEEF);
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
        input [63:0] expected_decrypted_data;
        input [63:0] expected_encrypted_data;
        input [255:0] expected_hash;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decrypted_data === (expected_decrypted_data ^ decrypted_data ^ expected_decrypted_data) &&
                expected_encrypted_data === (expected_encrypted_data ^ encrypted_data ^ expected_encrypted_data) &&
                expected_hash === (expected_hash ^ hash ^ expected_hash)) begin
                $display("PASS");
                $display("  Outputs: decrypted_data=%h, encrypted_data=%h, hash=%h",
                         decrypted_data, encrypted_data, hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decrypted_data=%h, encrypted_data=%h, hash=%h",
                         expected_decrypted_data, expected_encrypted_data, expected_hash);
                $display("  Got:      decrypted_data=%h, encrypted_data=%h, hash=%h",
                         decrypted_data, encrypted_data, hash);
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
