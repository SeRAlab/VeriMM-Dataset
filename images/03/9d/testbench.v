`timescale 1ns/1ps

module aes_encryption_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] key;
    reg [127:0] plaintext;
    wire [127:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_encryption dut (
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard FIPS 197 Round 1 Vector", test_num);


            plaintext = 128'h00102030405060708090a0b0c0d0e0f0;
            key       = 128'hd6aa74fdd2af72fadaa678f1d6ab76fe;

            #1;


            check_outputs(128'h89d814e8855ac4682d1843d8cb128fed);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Input", test_num);





            plaintext = 128'h00000000000000000000000000000000;
            key       = 128'h00000000000000000000000000000000;
            #1;

            check_outputs(128'h63636363636363636363636363636363);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Plaintext with Zero Key", test_num);





            plaintext = 128'hffffffffffffffffffffffffffffffff;
            key       = 128'h00000000000000000000000000000000;
            #1;

            check_outputs(128'h16161616161616161616161616161616);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Plaintext", test_num);




            plaintext = 128'h55555555555555555555555555555555;
            key       = 128'h00000000000000000000000000000000;
            #1;

            check_outputs(128'hfcfcfcfcfcfcfcfcfcfcfcfcfcfcfcfc);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Custom State and Round Key", test_num);


            plaintext = 128'h3243f6a8885a308d313198a2e0370734;
            key       = 128'h2b7e151628aed2a6abf7158809cf4f3c;





            #1;






            check_outputs(128'h91fafd33faea7f76fb52b6d8a662bae8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_encryption Testbench");
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
        input [127:0] expected_ciphertext;
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
