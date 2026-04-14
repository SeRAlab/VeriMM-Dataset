`timescale 1ns/1ps

module des_encryption_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] key;
    reg [4:0] plaintext;
    wire [4:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    des_encryption dut (
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All Zeros", test_num);
        plaintext = 5'b00000;
        key       = 5'b00000;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Plaintext All Ones, Key Zeros", test_num);
        plaintext = 5'b11111;
        key       = 5'b00000;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Plaintext Zeros, Key All Ones", test_num);
        plaintext = 5'b00000;
        key       = 5'b11111;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: All Ones (Self-Inverse)", test_num);
        plaintext = 5'b11111;
        key       = 5'b11111;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Alternating Bits", test_num);
        plaintext = 5'b10101;
        key       = 5'b01010;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Random Pattern A", test_num);
        plaintext = 5'b11001;
        key       = 5'b01101;
        #1;

        check_outputs(5'b10100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Random Pattern B", test_num);
        plaintext = 5'b00111;
        key       = 5'b10101;
        #1;

        check_outputs(5'b10010);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("des_encryption Testbench");
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
        input [4:0] expected_ciphertext;
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
