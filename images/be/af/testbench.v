`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] p_mosi;
    reg p_valid;
    reg rst_n;
    wire [511:0] sha_block;
    wire sha_init;
    wire sha_mode;
    wire sha_next;

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
        .sha_block(sha_block),
        .sha_init(sha_init),
        .sha_mode(sha_mode),
        .sha_next(sha_next)
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
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(512'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        reg [255:0] data;
        begin
            reset_dut();
            data = 256'hABCDEFFEDCBA98765432101234567890ABCDEFFEDCBA98765432101234567890;
            p_mosi = data;
            p_valid = 1;
            @(posedge clk);


            #1;



            check_outputs({data, SHA_PADDING}, 1'b1, 1'b1, 1'b0);
            p_valid = 0;
        end
        endtask

    task testcase003;

        reg [255:0] data;
        begin
            reset_dut();
            data = 256'h00112233445566778899AABBCCDDEEFF00112233445566778899AABBCCDDEEFF;
            p_mosi = data;
            p_valid = 1;
            @(posedge clk);
            p_valid = 0;
            @(posedge clk);

            #1;


            check_outputs({data, SHA_PADDING}, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            p_mosi = 256'h0;
            p_valid = 1;
            @(posedge clk);
            #1;

            check_outputs({256'h0, SHA_PADDING}, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            p_mosi = {256{1'b1}};
            p_valid = 1;
            @(posedge clk);
            #1;

            check_outputs({{256{1'b1}}, SHA_PADDING}, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        reg [255:0] data;
        begin
            reset_dut();
            data = 256'h5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A;
            p_mosi = data;
            p_valid = 1;
            @(posedge clk);
            p_valid = 0;
            p_mosi = 256'h0;
            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs({data, SHA_PADDING}, 1'b0, 1'b1, 1'b0);
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
        input [511:0] expected_sha_block;
        input expected_sha_init;
        input expected_sha_mode;
        input expected_sha_next;
        begin
            if (expected_sha_block === (expected_sha_block ^ sha_block ^ expected_sha_block) &&
                expected_sha_init === (expected_sha_init ^ sha_init ^ expected_sha_init) &&
                expected_sha_mode === (expected_sha_mode ^ sha_mode ^ expected_sha_mode) &&
                expected_sha_next === (expected_sha_next ^ sha_next ^ expected_sha_next)) begin
                $display("PASS");
                $display("  Outputs: sha_block=%h, sha_init=%b, sha_mode=%b, sha_next=%b",
                         sha_block, sha_init, sha_mode, sha_next);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sha_block=%h, sha_init=%b, sha_mode=%b, sha_next=%b",
                         expected_sha_block, expected_sha_init, expected_sha_mode, expected_sha_next);
                $display("  Got:      sha_block=%h, sha_init=%b, sha_mode=%b, sha_next=%b",
                         sha_block, sha_init, sha_mode, sha_next);
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
        $dumpvars(0,clk, p_mosi, p_valid, rst_n, sha_block, sha_init, sha_mode, sha_next);
    end

endmodule
