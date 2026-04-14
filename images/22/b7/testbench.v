`timescale 1ns/1ps

module aes_256_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [255:0] plaintext;
    reg reset;
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
        .reset(reset),
        .ciphertext(ciphertext)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        key = 0;
        plaintext = 0;
        repeat(2) @(posedge clk);
        reset = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task wait_cycles;

        input integer cycles;
        begin
            repeat(cycles) @(posedge clk);
        end
        endtask

    task testcase001;

    begin
        $display("\nRunning Testcase 001: All Zeros");
        reset_dut();
        key = 256'h0000000000000000000000000000000000000000000000000000000000000000;
        plaintext = 256'h0000000000000000000000000000000000000000000000000000000000000000;
        wait_cycles(50);



        #1;




        check_outputs(256'hdc95c078a240898953ad1ddc463439efdc95c078a240898953ad1ddc463439ef);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning Testcase 002: All Ones");
        reset_dut();
        key = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        plaintext = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        wait_cycles(50);

        #1;


        check_outputs(256'h8399589d81369794e759f379e578875e8399589d81369794e759f379e578875e);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning Testcase 003: Specific Hex Pattern");
        reset_dut();
        key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
        plaintext = 256'h00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff;
        wait_cycles(50);

        #1;


        check_outputs(256'h8ea2b7ca516745bfeafc49904b4960898ea2b7ca516745bfeafc49904b496089);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning Testcase 004: Alternating Pattern");
        reset_dut();
        key = 256'h5555555555555555555555555555555555555555555555555555555555555555;
        plaintext = 256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
        wait_cycles(50);
        #1;

        check_outputs(256'h0d62d23c14c5144b67946850c82270960d62d23c14c5144b67946850c8227096);
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
        $dumpvars(0,clk, key, plaintext, reset, ciphertext);
    end

endmodule
