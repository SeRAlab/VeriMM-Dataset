`timescale 1ns/1ps

module aes_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] key;
    reg [7:0] plaintext;
    wire [7:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_round dut (
        .clk(clk),
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            plaintext = 8'h00;
            key = 8'h00;
            test_num = test_num + 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            plaintext = 8'h00;
            key = 8'h00;
            @(posedge clk);
            #2;
            $display("Test Case 001: Zero Plaintext, Zero Key");
            #1;

            check_outputs(8'h63);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            plaintext = 8'h01;
            key = 8'h00;
            @(posedge clk);
            #2;
            $display("Test Case 002: Plaintext 01, Zero Key");
            #1;

            check_outputs(8'h7c);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            plaintext = 8'h00;
            key = 8'hFF;
            @(posedge clk);
            #2;
            $display("Test Case 003: Zero Plaintext, Key FF");
            #1;

            check_outputs(8'h9c);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            plaintext = 8'h4A;
            key = 8'h12;
            @(posedge clk);
            #2;
            $display("Test Case 004: Plaintext 4A, Key 12");
            #1;

            check_outputs(8'hc4);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            plaintext = 8'hFF;
            key = 8'hAA;
            @(posedge clk);
            #2;
            $display("Test Case 005: Plaintext FF, Key AA");
            #1;

            check_outputs(8'hbc);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            plaintext = 8'h21;
            key = 8'h34;
            @(posedge clk);
            #2;
            $display("Test Case 006: Plaintext 21, Key 34");
            #1;

            check_outputs(8'hc9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_round Testbench");
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
        $dumpvars(0,clk, key, plaintext, ciphertext);
    end

endmodule
