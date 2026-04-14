`timescale 1ns/1ps

module DES_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] key;
    reg [63:0] plaintext;
    wire [63:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DES dut (
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            key = 64'h0000000000000000;
            plaintext = 64'h0000000000000000;

            #1;


            check_outputs(64'h8ca64de9c1b123a7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard NIST KAT", test_num);
            key = 64'h133457799BBCDFF1;
            plaintext = 64'h0123456789ABCDEF;
            #1;

            check_outputs(64'h3FA40E8A984D4815);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High-Entropy Input", test_num);
            key = 64'h0E329232EA6D0D73;
            plaintext = 64'h8787878787878787;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Pattern", test_num);
            key = 64'hAAAAAAAAAAAAAAAA;
            plaintext = 64'h5555555555555555;

            #1;


            check_outputs(64'h1E03AD6471BE325E);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: NIST Test Vector - Diverse Values", test_num);
            key = 64'h7CA110454A1A6E57;
            plaintext = 64'h01A1D6D039776742;
            #1;

            check_outputs(64'h690F5B0D9A26939B);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Key", test_num);
            key = 64'hFFFFFFFFFFFFFFFF;
            plaintext = 64'hFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(64'h7359B2163E4EDC58);
        end
        endtask

    task testcases1;

        begin
            testcase001();
            testcase002();
            testcase003();
        end
        endtask

    task testcases2;

        begin
            testcase004();
            testcase005();
            testcase006();
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DES Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcases1();
        testcases2();
        
        
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
