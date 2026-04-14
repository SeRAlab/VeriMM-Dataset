`timescale 1ns/1ps

module aes_256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [255:0] plaintext;
    reg rst;
    reg start;
    wire [255:0] ciphertext;
    wire valid;

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
        .start(start),
        .ciphertext(ciphertext),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            key = 0;
            plaintext = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All-Zero Input", test_num);
            reset_dut();

            key = 256'h0;
            plaintext = 256'h0;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(valid === 1);
            @(posedge clk);



            #1;




            check_outputs(256'hdc95c078a240898953ad1ddc21035b73dc95c078a240898953ad1ddc21035b73, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: NIST Standard Vector", test_num);
            reset_dut();


            key = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4;

            plaintext = 256'h6bc1bee22e409f96e93d7e117393172a6bc1bee22e409f96e93d7e117393172a;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(valid === 1);
            @(posedge clk);


            #1;



            check_outputs(256'hf3eed1bdb5d2a03c061980848a62550af3eed1bdb5d2a03c061980848a62550a, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: All-Ones Input", test_num);
            reset_dut();

            key = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            plaintext = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(valid === 1);
            @(posedge clk);


            #1;



            check_outputs(256'h6df2080a4303e990b79788f28972e61a6df2080a4303e990b79788f28972e61a, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Mixed Values", test_num);
            reset_dut();

            key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            plaintext = 256'h00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(valid === 1);
            @(posedge clk);


            #1;



            check_outputs(256'h8ea2b7ca516745bfeafc49904b4960898ea2b7ca516745bfeafc49904b496089, 1'b1);
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
        input expected_valid;
        begin
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h, valid=%b",
                         ciphertext, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h, valid=%b",
                         expected_ciphertext, expected_valid);
                $display("  Got:      ciphertext=%h, valid=%b",
                         ciphertext, valid);
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
        $dumpvars(0,clk, key, plaintext, rst, start, ciphertext, valid);
    end

endmodule
