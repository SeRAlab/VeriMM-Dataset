`timescale 1ns/1ps

module DES_round_tb;

    // Testbench signals (combinational circuit)
    reg [55:0] key;
    reg [63:0] plaintext;
    wire [63:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DES_round dut (
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros Input", test_num);
        plaintext = 64'h0000000000000000;
        key = 56'h00000000000000;
        #10;

        #1;


        check_outputs(64'h8DA2A7425F8E104F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones Input", test_num);
        plaintext = 64'hFFFFFFFFFFFFFFFF;
        key = 56'hFFFFFFFFFFFFFF;
        #10;

        #1;


        check_outputs(64'hE24584282717E6BB);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Standard Hex Pattern", test_num);
        plaintext = 64'h0123456789ABCDEF;
        key = 56'h133457799BBCDF;
        #10;

        #1;


        check_outputs(64'h3CF03C0F52E3E34C);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bit Pattern", test_num);
        plaintext = 64'h5555555555555555;
        key = 56'hAAAAAAAAAAAAAA;
        #10;

        #1;


        check_outputs(64'h3A26D273010E862D);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single Bit Set", test_num);
        plaintext = 64'h8000000000000000;
        key = 56'h00000000000000;
        #10;

        #1;


        check_outputs(64'h8C934E9B9720C70E);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single Bit Key Set", test_num);
        plaintext = 64'h0000000000000000;
        key = 56'h00000000000001;
        #10;

        #1;


        check_outputs(64'h69E5B5D5B5A10A3E);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Nibble Boundary Pattern", test_num);
        plaintext = 64'hF0F0F0F0F0F0F0F0;
        key = 56'h0F0F0F0F0F0F0F;
        #10;

        #1;


        check_outputs(64'h8B3F5D6B609E2B0D);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DES_round Testbench");
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
