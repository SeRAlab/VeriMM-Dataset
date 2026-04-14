`timescale 1ns/1ps

module AES_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [7:0] plaintext;
    reg reset;
    wire [7:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AES_8bit dut (
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
        plaintext = 8'h0;
        key = 128'h0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: All Zeros (Plaintext=0, Key=0)", test_num);
        reset_dut();
        plaintext = 8'h00;
        key = 128'h0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h3E);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Max Plaintext (Plaintext=FF, Key=0)", test_num);
        reset_dut();
        plaintext = 8'hFF;
        key = 128'h0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hA2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Complex Key, Zero Plaintext", test_num);
        reset_dut();
        plaintext = 8'h00;
        key = 128'h0123456789ABCDEF0123456789ABCDEF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hF4);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Alternating Bits", test_num);
        reset_dut();
        plaintext = 8'hAA;
        key = 128'h55555555555555555555555555555555;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h1B);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Determinism Check (Repeating 001)", test_num);
        reset_dut();
        plaintext = 8'h00;
        key = 128'h0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h3E);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Avalanche Effect (Plaintext 00 vs 01)", test_num);
        reset_dut();
        plaintext = 8'h01;
        key = 128'h0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'hD7);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AES_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_ciphertext;
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
