`timescale 1ns/1ps

module AES_AddRoundKey_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] key;
    reg [127:0] plaintext;
    wire [127:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AES_AddRoundKey dut (
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: All Zeros (Identity Property)", test_num);
            plaintext = 128'h0;
            key       = 128'h0;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: All Ones (Flipping Property)", test_num);
            plaintext = 128'h0;
            key       = 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
            #1;

            check_outputs(128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: NIST AES-128 Example Vector (Round 0 Key Addition)", test_num);

            plaintext = 128'h3243f6a8885a308d313198a2e0370734;
            key       = 128'h2b7e151628aed2a6abf7158809cf4f3c;

            #1;


            check_outputs(128'h193de3bea0f4e22b9ac68d2ae9f84808);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: Identical Inputs (Zero Result Property)", test_num);
            plaintext = 128'hA5A5A5A5_5A5A5A5A_DEADBEEF_C0DEBABE;
            key       = 128'hA5A5A5A5_5A5A5A5A_DEADBEEF_C0DEBABE;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: Alternating Bit Pattern", test_num);
            plaintext = 128'h55555555_55555555_55555555_55555555;
            key       = 128'hAAAAAAAA_AAAAAAAA_AAAAAAAA_AAAAAAAA;
            #1;

            check_outputs(128'hFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: Single Bit Toggles", test_num);
            plaintext = 128'h00000000_00000000_00000000_00000001;
            key       = 128'h80000000_00000000_00000000_00000000;
            #1;

            check_outputs(128'h80000000_00000000_00000000_00000001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AES_AddRoundKey Testbench");
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
