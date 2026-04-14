`timescale 1ns/1ps

module aes_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] key;
    reg [7:0] plain_text;
    reg rst;
    wire [7:0] cipher_text;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_8bit dut (
        .clk(clk),
        .key(key),
        .plain_text(plain_text),
        .rst(rst),
        .cipher_text(cipher_text)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        key = 8'h00;
        plain_text = 8'h00;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: All Zeros", test_num);
        reset_dut();
        key = 8'h00;
        plain_text = 8'h00;

        repeat(5) @(posedge clk);
        #1;

        check_outputs(8'h63);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Alternating Bits 0xAA", test_num);
        reset_dut();
        key = 8'hFF;
        plain_text = 8'hAA;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(8'hD4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Maximum Values", test_num);
        reset_dut();
        key = 8'h55;
        plain_text = 8'hFF;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Key Sensitivity Test", test_num);
        reset_dut();
        key = 8'h12;
        plain_text = 8'h34;
        repeat(5) @(posedge clk);

        #1;


        check_outputs(8'h89);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Data Sensitivity Test", test_num);
        reset_dut();
        key = 8'h12;
        plain_text = 8'hF0;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(8'hA7);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_8bit Testbench");
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
        input [7:0] expected_cipher_text;
        begin
            if (expected_cipher_text === (expected_cipher_text ^ cipher_text ^ expected_cipher_text)) begin
                $display("PASS");
                $display("  Outputs: cipher_text=%h",
                         cipher_text);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cipher_text=%h",
                         expected_cipher_text);
                $display("  Got:      cipher_text=%h",
                         cipher_text);
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
        $dumpvars(0,clk, key, plain_text, rst, cipher_text);
    end

endmodule
