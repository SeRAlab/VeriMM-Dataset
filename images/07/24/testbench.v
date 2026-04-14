`timescale 1ns/1ps

module des_encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] key;
    reg [15:0] plaintext;
    reg reset;
    wire [15:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    des_encryption dut (
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
            plaintext = 0;
            key = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            plaintext = 16'h0000;
            key = 16'h0000;

            repeat(20) @(posedge clk);
            $display("testcase001: All Zeros");
            #1;

            check_outputs(16'hA3B1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            plaintext = 16'hFFFF;
            key = 16'hFFFF;
            repeat(20) @(posedge clk);
            $display("testcase002: All Ones");
            #1;

            check_outputs(16'h5D2E);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            plaintext = 16'hAAAA;
            key = 16'h5555;
            repeat(20) @(posedge clk);
            $display("testcase003: Alternating Bits");
            #1;

            check_outputs(16'hC912);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            plaintext = 16'h1234;
            key = 16'hABCD;
            repeat(20) @(posedge clk);
            $display("testcase004: Mixed Pattern 1");
            #1;

            check_outputs(16'h789A);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            plaintext = 16'hDEAD;
            key = 16'hBEEF;
            repeat(20) @(posedge clk);
            $display("testcase005: Mixed Pattern 2");
            #1;

            check_outputs(16'h4321);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("des_encryption Testbench");
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
        input [15:0] expected_ciphertext;
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
