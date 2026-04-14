`timescale 1ns/1ps

module DES_single_round_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] key;
    reg [63:0] plaintext;
    wire [63:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DES_single_round dut (
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros (Plaintext and Key)", test_num);
        plaintext = 64'h0000000000000000;
        key       = 64'h0000000000000000;



        #1;




        check_outputs(64'h8ca64de9c1b123a7);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones (Plaintext and Key)", test_num);
        plaintext = 64'hFFFFFFFFFFFFFFFF;
        key       = 64'hFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(64'h7359b2163e4edc58);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Standard Hex Sequence Test Vector", test_num);
        plaintext = 64'h0123456789ABCDEF;
        key       = 64'h133457799BBCDFF1;

        #1;


        check_outputs(64'hda02ce3a89ecac3b);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Checkerboard Pattern (AA/55)", test_num);
        plaintext = 64'h5555555555555555;
        key       = 64'hAAAAAAAAAAAAAAAA;
        #1;

        check_outputs(64'h0e3cc9d08e983411);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Complement Checkerboard Pattern", test_num);
        plaintext = 64'hAAAAAAAAAAAAAAAA;
        key       = 64'h5555555555555555;
        #1;

        check_outputs(64'hb49e0f6b453e9824);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Key Sensitivity (1-bit difference from Test 3)", test_num);
        plaintext = 64'h0123456789ABCDEF;
        key       = 64'h133457799BBCDFF0;
        #1;

        check_outputs(64'hda02ce3a39e8ac3b);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Walking One in Plaintext", test_num);
        plaintext = 64'h8000000000000000;
        key       = 64'h0000000000000000;
        #1;

        check_outputs(64'h01a248e9c1b123a7);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DES_single_round Testbench");
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
        input [63:0] expected_ciphertext;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h",
                         ciphertext);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h",
                         expected_ciphertext);
                $display("  Got:      ciphertext=%h",
                         ciphertext);
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
