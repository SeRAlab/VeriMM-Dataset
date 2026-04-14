`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] p_mosi;
    reg p_valid;
    reg rst_n;
    reg [255:0] sha_digest;
    wire [255:0] p_miso;
    wire [511:0] sha_block;
    wire sha_init;
    wire sha_mode;
    wire sha_next;
    wire sha_reset_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .p_mosi(p_mosi),
        .p_valid(p_valid),
        .rst_n(rst_n),
        .sha_digest(sha_digest),
        .p_miso(p_miso),
        .sha_block(sha_block),
        .sha_init(sha_init),
        .sha_mode(sha_mode),
        .sha_next(sha_next),
        .sha_reset_n(sha_reset_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            p_mosi = 0;
            p_valid = 0;
            sha_digest = 0;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Idle State Check");
            reset_dut();

            #1;


            check_outputs(256'h0, 512'h0, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Transition to Valid (sha_init pulse)");
            reset_dut();
            p_valid = 1;
            p_mosi = 256'hA5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5;
            @(posedge clk);
            #2;

            #1;


            check_outputs(256'h0, {256'hA5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5, 256'h0}, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Sustained Valid (sha_init logic)");
            reset_dut();
            p_valid = 1;
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(256'h0, 512'h0, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Data Passthrough (p_miso)");
            reset_dut();
            p_valid = 1;
            sha_digest = 256'hDEADBEEF_00001111_22223333_44445555_66667777_88889999_AAAABBBB_CCCCDDDD;
            p_mosi = 256'h12345678_12345678_12345678_12345678_12345678_12345678_12345678_12345678;
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(256'hDEADBEEF_00001111_22223333_44445555_66667777_88889999_AAAABBBB_CCCCDDDD,
                          {256'h12345678_12345678_12345678_12345678_12345678_12345678_12345678_12345678, 256'h0},
                          1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Validity Withdrawal");
            reset_dut();
            p_valid = 1;
            @(posedge clk);
            p_valid = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(256'h0, 512'h0, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [255:0] expected_p_miso;
        input [511:0] expected_sha_block;
        input expected_sha_init;
        input expected_sha_mode;
        input expected_sha_next;
        input expected_sha_reset_n;
        begin
            if (expected_p_miso === (expected_p_miso ^ p_miso ^ expected_p_miso) &&
                expected_sha_block === (expected_sha_block ^ sha_block ^ expected_sha_block) &&
                expected_sha_init === (expected_sha_init ^ sha_init ^ expected_sha_init) &&
                expected_sha_mode === (expected_sha_mode ^ sha_mode ^ expected_sha_mode) &&
                expected_sha_next === (expected_sha_next ^ sha_next ^ expected_sha_next) &&
                expected_sha_reset_n === (expected_sha_reset_n ^ sha_reset_n ^ expected_sha_reset_n)) begin
                $display("PASS");
                $display("  Outputs: p_miso=%h, sha_block=%h, sha_init=%b, sha_mode=%b, sha_next=%b, sha_reset_n=%b",
                         p_miso, sha_block, sha_init, sha_mode, sha_next, sha_reset_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p_miso=%h, sha_block=%h, sha_init=%b, sha_mode=%b, sha_next=%b, sha_reset_n=%b",
                         expected_p_miso, expected_sha_block, expected_sha_init, expected_sha_mode, expected_sha_next, expected_sha_reset_n);
                $display("  Got:      p_miso=%h, sha_block=%h, sha_init=%b, sha_mode=%b, sha_next=%b, sha_reset_n=%b",
                         p_miso, sha_block, sha_init, sha_mode, sha_next, sha_reset_n);
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
        $dumpvars(0,clk, p_mosi, p_valid, rst_n, sha_digest, p_miso, sha_block, sha_init, sha_mode, sha_next, sha_reset_n);
    end

endmodule
