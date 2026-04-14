`timescale 1ns/1ps

module aes_8bit_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] iv;
    reg [127:0] key;
    reg [7:0] plaintext;
    reg rst;
    wire [7:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_8bit_encrypt dut (
        .clk(clk),
        .iv(iv),
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
            iv = 0;
            key = 0;
            plaintext = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            plaintext = 8'h00;
            iv = 8'h00;
            key = 128'h0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'h63);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            plaintext = 8'hAA;
            iv = 8'h00;
            key = 128'h0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'hAC);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            plaintext = 8'hAA;
            iv = 8'hFF;
            key = 128'h0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h52);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            plaintext = 8'hAA;
            iv = 8'h00;
            key = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'hDE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            plaintext = 8'h55;
            iv = 8'hAA;
            key = 128'h0123456789ABCDEF0123456789ABCDEF;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h24);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_8bit_encrypt Testbench");
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
        $dumpvars(0,clk, iv, key, plaintext, rst, ciphertext);
    end

endmodule
