`timescale 1ns/1ps

module AES_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] plaintext;
    reg rst;
    wire [127:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AES_round dut (
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
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: All Zeros Input...");
            reset_dut();
            plaintext = 128'h00000000000000000000000000000000;
            key       = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h63636363636363636363636363636363);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: NIST FIPS 197 Round 1 Vector...");
            reset_dut();

            plaintext = 128'h00102030405060708090a0b0c0d0e0f0;

            key       = 128'hd6aa74fdd2af72fadaa678f1d6ab76fe;
            @(posedge clk);
            #1;

            #1;


            check_outputs(128'h89d810e8855a375d1f1a74a5c344a71f);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: All Ones Input with Zero Key...");
            reset_dut();
            plaintext = 128'hffffffffffffffffffffffffffffffff;
            key       = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h16161616161616161616161616161616);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Non-uniform state...");
            reset_dut();

            plaintext = 128'h193de3bea0f4e22b9ac68d2ae9e8ec48;
            key       = 128'ha0fafe1788542cb123a339392a6c7605;
            @(posedge clk);
            #1;

            #1;


            check_outputs(128'ha4686b029c9f2c258285ed17b1d92f7b);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AES_round Testbench");
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
