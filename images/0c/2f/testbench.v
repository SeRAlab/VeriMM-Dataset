`timescale 1ns/1ps

module aes_256_tb;

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
    aes_256 dut (
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
            key = 0;
            plaintext = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: All Zeroes...");
            reset_dut();
            test_num = test_num + 1;
            plaintext = 256'h0;
            key = 256'h0;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(256'hdc95c078a2408989ad31ed5703774880dc95c078a2408989ad31ed5703774880);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Specific Plaintext with Zero Key...");
            reset_dut();
            test_num = test_num + 1;
            plaintext = 256'h0123456789abcdeffedcba98765432100123456789abcdeffedcba9876543210;
            key = 256'h0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(256'h53443313271c7b8979393e878508129753443313271c7b8979393e8785081297);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: All Ones...");
            reset_dut();
            test_num = test_num + 1;
            plaintext = {256{1'b1}};
            key = {256{1'b1}};
            repeat(20) @(posedge clk);
            #1;

            check_outputs(256'h4f9976f3f054700d5a374665f8a0a2564f9976f3f054700d5a374665f8a0a256);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Alternating Bit Pattern...");
            reset_dut();
            test_num = test_num + 1;
            plaintext = 256'h5555555555555555555555555555555555555555555555555555555555555555;
            key = 256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(256'h719a9709214777a8847f967a14769018719a9709214777a8847f967a14769018);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Incremental Data Pattern...");
            reset_dut();
            test_num = test_num + 1;
            plaintext = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            key = 256'h1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(256'hbc00067347a5482362076088924157128ea2b7ca516745bfeafc49904b496089);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_256 Testbench");
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
