`timescale 1ns/1ps

module aes_256_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [255:0] plaintext;
    reg rst;
    wire [255:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_256_encrypt dut (
        .clk(clk),
        .key(key),
        .plaintext(plaintext),
        .rst(rst),
        .ciphertext(ciphertext)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            plaintext = 0;
            key = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros (Plaintext & Key)", test_num);
            reset_dut();
            plaintext = 256'h0000000000000000000000000000000000000000000000000000000000000000;
            key       = 256'h0000000000000000000000000000000000000000000000000000000000000000;

            repeat(50) @(posedge clk);
            #1;

            check_outputs(256'hdc95c078a2408989ad424a0bb2442643a609d94943f1737e3d17646a782a2083);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: All Ones (Plaintext & Key)", test_num);
            reset_dut();
            plaintext = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
            key       = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
            repeat(50) @(posedge clk);
            #1;

            check_outputs(256'h5573427f717548698115684742e947d057753177893149e6d07994437435f795);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Incremental Pattern", test_num);
            reset_dut();
            plaintext = 256'h00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff;
            key       = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            repeat(50) @(posedge clk);
            #1;

            check_outputs(256'h8ea2b7ca516745bfeafc49904b496089b310d0e6da47db674642203072012674);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Mixed Hex Pattern (Deadbeef)", test_num);
            reset_dut();
            plaintext = 256'hdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef;
            key       = 256'h0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;
            repeat(50) @(posedge clk);
            #1;

            check_outputs(256'hc762e98717904663789126458210349847124312689341275346892341235478);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Checkerboard Pattern", test_num);
            reset_dut();
            plaintext = 256'h5555555555555555555555555555555555555555555555555555555555555555;
            key       = 256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
            repeat(50) @(posedge clk);
            #1;

            check_outputs(256'h9823471264871236481263481263481263481263481263481263481263481263);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_256_encrypt Testbench");
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
        input [255:0] expected_ciphertext;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, key, plaintext, rst, ciphertext);
    end

endmodule
