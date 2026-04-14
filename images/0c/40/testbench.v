`timescale 1ns/1ps

module aes_256_encryption_tb;

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
    aes_256_encryption dut (
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
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            plaintext = 256'h0;
            key       = 256'h0;

            repeat(20) @(posedge clk);
            $display("Testcase %03d: All Zeros", test_num);
            #1;

            check_outputs(256'hdc95c078a2408989ad48a21492842087dc95c078a2408989ad48a21492842087);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            plaintext = 256'h6bc1bee22e409f96e93d7e117393172a6bc1bee22e409f96e93d7e117393172a;
            key       = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4;
            repeat(20) @(posedge clk);
            $display("Testcase %03d: NIST Vector", test_num);
            #1;

            check_outputs(256'hf3eed1bdb5d2a03c064b5a7e3db181f8f3eed1bdb5d2a03c064b5a7e3db181f8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            plaintext = 256'h6bc1bee22e409f96e93d7e117393172b6bc1bee22e409f96e93d7e117393172b;
            key       = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4;
            repeat(20) @(posedge clk);
            $display("Testcase %03d: Plaintext Sensitivity (Single Bit Change)", test_num);
            #1;

            check_outputs(256'h2499719323c6d7a44f33b1e5a59a6d0c2499719323c6d7a44f33b1e5a59a6d0c);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            plaintext = 256'h00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff;
            key       = 256'h0000000000000000000000000000000000000000000000000000000000000001;
            repeat(20) @(posedge clk);
            $display("Testcase %03d: Key Sensitivity (Single Bit Change)", test_num);
            #1;

            check_outputs(256'h55f26941197063d99434e38e6840d51355f26941197063d99434e38e6840d513);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            plaintext = {256{1'b1}};
            key       = {256{1'b1}};
            repeat(20) @(posedge clk);
            $display("Testcase %03d: All Ones", test_num);
            #1;

            check_outputs(256'h7570776b713280879647242d5939226d7570776b713280879647242d5939226d);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_256_encryption Testbench");
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
        $dumpvars(0,clk, key, plaintext, reset, ciphertext);
    end

endmodule
