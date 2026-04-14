`timescale 1ns/1ps

module aes_256_tb;

    // Testbench signals (sequential circuit)
    reg [255:0] key;
    reg [255:0] plaintext;
    reg valid;
    wire [255:0] ciphertext;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_256 dut (
        .key(key),
        .plaintext(plaintext),
        .valid(valid),
        .ciphertext(ciphertext),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        valid = 0;
        forever #5 valid = ~valid;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            key = 0;
            plaintext = 0;


            repeat (5) @(posedge valid);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Running Testcase 001: All Zeros...");
            key = 256'h0;
            plaintext = 256'h0;


            wait(ready == 1);
            @(negedge valid);



            #1;




            check_outputs(256'hdc95c078a2408989ad48a21492842087dc95c078a2408989ad48a21492842087, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Running Testcase 002: NIST KAT Pattern...");

            key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;

            plaintext = 256'h00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff;

            wait(ready == 1);
            @(negedge valid);


            #1;



            check_outputs(256'h8ea2b7ca516745bfeafc49904b4960898ea2b7ca516745bfeafc49904b496089, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Running Testcase 003: All Ones...");
            key = {256{1'b1}};
            plaintext = {256{1'b1}};

            wait(ready == 1);
            @(negedge valid);


            #1;



            check_outputs(256'he26038459463426e25406367353f868ae26038459463426e25406367353f868a, 1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Running Testcase 004: Alternating Bits...");
            key = 256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            plaintext = 256'h5555555555555555555555555555555555555555555555555555555555555555;

            wait(ready == 1);
            @(negedge valid);

            #1;


            check_outputs(256'h7221295368a18356f96602336338e9c27221295368a18356f96602336338e9c2, 1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Running Testcase 005: Key/PT Mixed Hex...");
            key = 256'hDEADC0DEBEEFBABECAFED00D1234567887654321D00DAFECCABEBEEFDEC0DAED;
            plaintext = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;

            wait(ready == 1);
            @(negedge valid);


            #1;



            check_outputs(256'h4941910242131908605423854128032449419102421319086054238541280324, 1);
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
        input expected_ready;
        begin
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h, ready=%b",
                         ciphertext, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h, ready=%b",
                         expected_ciphertext, expected_ready);
                $display("  Got:      ciphertext=%h, ready=%b",
                         ciphertext, ready);
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
        $dumpvars(0,key, plaintext, valid, ciphertext, ready);
    end

endmodule
