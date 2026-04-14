`timescale 1ns/1ps

module aes_round_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] key;
    reg [127:0] plaintext;
    wire [127:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_round dut (
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros", test_num);
        plaintext = 128'h00000000000000000000000000000000;
        key       = 128'h00000000000000000000000000000000;
        #1;

        check_outputs(128'h63636363636363636363636363636363);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones", test_num);
        plaintext = 128'hffffffffffffffffffffffffffffffff;
        key       = 128'hffffffffffffffffffffffffffffffff;
        #1;

        check_outputs(128'he9e9e9e9e9e9e9e9e9e9e9e9e9e9e9e9);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Checkerboard Pattern", test_num);
        plaintext = 128'ha5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5;
        key       = 128'h5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a;

        #1;


        check_outputs(128'h5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: NIST-like Round Input", test_num);
        plaintext = 128'h00112233445566778899aabbccddeeff;
        key       = 128'h00000000000000000000000000000000;

        #1;


        check_outputs(128'hc9e8460662d5174179b006800d3d63c5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Walking Bit Key", test_num);
        plaintext = 128'h00000000000000000000000000000000;
        key       = 128'h80000000000000000000000000000000;
        #1;

        check_outputs(128'he3636363636363636363636363636363);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_round Testbench");
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
