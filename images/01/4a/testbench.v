`timescale 1ns/1ps

module aes_128_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] plaintext;
    reg rst;
    reg start;
    wire [127:0] ciphertext;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_128 dut (
        .clk(clk),
        .key(key),
        .plaintext(plaintext),
        .rst(rst),
        .start(start),
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
            start = 0;
            key = 0;
            plaintext = 0;
            repeat(2) @(posedge clk);
            #2 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task run_encryption;

        input [127:0] in_plaintext;
        input [127:0] in_key;
        begin
            plaintext = in_plaintext;
            key = in_key;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            fork : wait_or_timeout
                begin
                    wait(done == 1'b1);
                    disable wait_or_timeout;
                end
                begin
                    #5000;
                    $display("Error: Timeout waiting for done signal");
                    disable wait_or_timeout;
                end
            join

            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTest Case %0d: All Zeros Vector", test_num);
            run_encryption(
                128'h00000000000000000000000000000000,
                128'h00000000000000000000000000000000
            );
            #1;

            check_outputs(128'h66e94bd4ef8a2c3b884cfa59ca342b2e, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTest Case %0d: NIST KAT Vector 1", test_num);
            run_encryption(
                128'h00112233445566778899aabbccddeeff,
                128'h000102030405060708090a0b0c0d0e0f
            );
            #1;

            check_outputs(128'h69c4e0d86a7b0430d8cdb78070b4c55a, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTest Case %0d: NIST SP 800-38A Vector", test_num);
            run_encryption(
                128'h6bc1bee22e409f96e93d7e117393172a,
                128'h2b7e151628aed2a6abf7158809cf4f3c
            );
            #1;

            check_outputs(128'h3ad77bb40d7a3660a89ecaf32466ef97, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTest Case %0d: All Ones Plaintext", test_num);

            run_encryption(
                128'hffffffffffffffffffffffffffffffff,
                128'h000102030405060708090a0b0c0d0e0f
            );
            #1;

            check_outputs(128'h164bc7754964585c5314050212f4625d, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_128 Testbench");
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
        $dumpvars(0,clk, key, plaintext, rst, start, ciphertext, done);
    end

endmodule
