`timescale 1ns/1ps

module aes256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [127:0] plaintext;
    reg rst;
    wire [127:0] ciphertext;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes256 dut (
        .clk(clk),
        .key(key),
        .plaintext(plaintext),
        .rst(rst),
        .ciphertext(ciphertext),
        .done(done)
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
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Test Case %0d: All Zeros", test_num);
            reset_dut();

            key = 256'h0000000000000000000000000000000000000000000000000000000000000000;
            plaintext = 128'h00000000000000000000000000000000;


            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(128'hdc95c078a2408989ad48a21492842087, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Test Case %0d: NIST Incremental Vector", test_num);
            reset_dut();

            key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            plaintext = 128'h00112233445566778899aabbccddeeff;

            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(128'h8ea2b7ca516745bfeafc49904b496089, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Test Case %0d: All Ones", test_num);
            reset_dut();

            key = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
            plaintext = 128'hffffffffffffffffffffffffffffffff;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(128'he71025d01e2894b51fd058075dc08830, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Test Case %0d: NIST KAT Vector", test_num);
            reset_dut();

            key = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4;
            plaintext = 128'h6bc1bee22e409f96e93d7e117393172a;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(128'hf3eed1bdb5d2a03c061980306a256926, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Test Case %0d: Random-Pattern Vector", test_num);
            reset_dut();

            key = 256'h0000000000000000000000000000000000000000000000000000000000000001;
            plaintext = 128'h00000000000000000000000000000001;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(128'h517007e05441d48c0828230232148118, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes256 Testbench");
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
        input expected_done;
        begin
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h, done=%b",
                         ciphertext, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h, done=%b",
                         expected_ciphertext, expected_done);
                $display("  Got:      ciphertext=%h, done=%b",
                         ciphertext, done);
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
        $dumpvars(0,clk, key, plaintext, rst, ciphertext, done);
    end

endmodule
