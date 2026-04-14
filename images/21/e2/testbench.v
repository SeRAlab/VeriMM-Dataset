`timescale 1ns/1ps

module aes_256_tb;

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
    aes_256 dut (
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
        repeat (2) @(posedge clk);
        #1 reset = 0;
        repeat (2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Zeros", test_num);
        reset_dut();

        key = 256'h0;
        plaintext = 256'h0;



        repeat (50) @(posedge clk);

        #1;


        check_outputs(256'hdc95c078a2408989ad48a21492842087dc95c078a2408989ad48a21492842087);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: NIST Standard Vector", test_num);
        reset_dut();

        key       = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
        plaintext = 256'h00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff;

        repeat (50) @(posedge clk);


        #1;



        check_outputs(256'h8ea2b7ca516745bfeafc49904b4960898ea2b7ca516745bfeafc49904b496089);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All F's Key", test_num);
        reset_dut();

        key       = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        plaintext = 256'h0123456789abcdeffedcba98765432100123456789abcdeffedcba9876543210;

        repeat (50) @(posedge clk);



        #1;




        check_outputs(256'h17004f2603883a910f5454659f848f1017004f2603883a910f5454659f848f10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Alternating Bits", test_num);
        reset_dut();

        key       = 256'h55555555555555555555555555555555aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
        plaintext = 256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa55555555555555555555555555555555;

        repeat (50) @(posedge clk);


        #1;



        check_outputs(256'h95e4125b04518921448b301712a2a0c441b835e5898d9482782b545d15f22e70);
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
