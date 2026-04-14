`timescale 1ns/1ps

module aes_encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg [127:0] key_in;
    reg rst;
    wire [127:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_encryption dut (
        .clk(clk),
        .data_in(data_in),
        .key_in(key_in),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        data_in = 128'b0;
        key_in = 128'b0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: All Zeros");
        reset_dut();
        data_in = 128'h00000000000000000000000000000000;
        key_in  = 128'h00000000000000000000000000000000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(128'h63636363636363636363636363636363);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Sequence Data, Zero Key");
        reset_dut();
        data_in = 128'h00112233445566778899aabbccddeeff;
        key_in  = 128'h00000000000000000000000000000000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(128'h046681e5e0cb199a48f8d6b1d1f625c9);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Sequence Data, Specific Key");
        reset_dut();
        data_in = 128'h00112233445566778899aabbccddeeff;
        key_in  = 128'h000102030405060708090a0b0c0d0e0f;
        @(posedge clk);
        #2;
        #1;

        check_outputs(128'h046783e6e4ce1fbdd0f1dcba09fb2bc6);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: All ones (0xFF)");
        reset_dut();
        data_in = 128'hffffffffffffffffffffffffffffffff;
        key_in  = 128'h00000000000000000000000000000000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(128'h16161616161616161616161616161616);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Zero Data, All ones Key");
        reset_dut();
        data_in = 128'h00000000000000000000000000000000;
        key_in  = 128'hffffffffffffffffffffffffffffffff;
        @(posedge clk);
        #2;
        #1;

        check_outputs(128'h9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c);
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
        input [127:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, key_in, rst, data_out);
    end

endmodule
