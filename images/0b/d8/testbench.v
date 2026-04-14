`timescale 1ns/1ps

module chacha20_core_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] key;
    reg [31:0] nonce;
    reg rst;
    wire [31:0] ciphertext;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_core dut (
        .clk(clk),
        .key(key),
        .nonce(nonce),
        .rst(rst),
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
        key = 32'h0;
        nonce = 32'h0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task wait_and_check;

        input [31:0] expected_val;
        begin

            while (!valid) begin
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(expected_val, 1'b1);
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Zeros", test_num);
        reset_dut();

        key = 32'h00000000;
        nonce = 32'h00000000;




        wait_and_check(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Ones", test_num);
        reset_dut();

        key = 32'hFFFFFFFF;
        nonce = 32'hFFFFFFFF;

        wait_and_check(32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Alternating Patterns", test_num);
        reset_dut();

        key = 32'hAAAAAAAA;
        nonce = 32'h55555555;

        wait_and_check(32'hAAAAAAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Incremental Values", test_num);
        reset_dut();

        key = 32'h12345678;
        nonce = 32'h9ABCDEF0;

        wait_and_check(32'h12345678);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Walking One", test_num);
        reset_dut();

        key = 32'h80000000;
        nonce = 32'h00000001;

        wait_and_check(32'h80000001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_core Testbench");
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
        input [31:0] expected_ciphertext;
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
        $dumpvars(0,clk, key, nonce, rst, ciphertext, valid);
    end

endmodule
