`timescale 1ns/1ps

module aes_encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] key;
    reg [7:0] plaintext;
    reg rst;
    wire [7:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_encryption dut (
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
            plaintext = 8'h0;
            key = 8'h0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            plaintext = 8'h00;
            key = 8'h00;
            repeat(2) @(posedge clk);
            $display("Test Case %0d: All Zeros", test_num);
            #1;

            check_outputs(8'h36);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            plaintext = 8'h01;
            key = 8'h00;
            repeat(2) @(posedge clk);
            $display("Test Case %0d: Identity XOR (Key=0)", test_num);
            #1;

            check_outputs(8'hC7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            plaintext = 8'hFF;
            key = 8'hFF;
            repeat(2) @(posedge clk);
            $display("Test Case %0d: All Bits Set (XOR result 0)", test_num);
            #1;

            check_outputs(8'h36);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            plaintext = 8'h41;
            key = 8'h12;
            repeat(2) @(posedge clk);
            $display("Test Case %0d: Arbitrary Pattern 1", test_num);
            #1;

            check_outputs(8'hDE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            plaintext = 8'hAA;
            key = 8'h55;
            repeat(2) @(posedge clk);
            $display("Test Case %0d: Alternating Bits (XOR result FF)", test_num);
            #1;

            check_outputs(8'h61);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_encryption Testbench");
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
        $dumpvars(0,clk, key, plaintext, rst, ciphertext);
    end

endmodule
