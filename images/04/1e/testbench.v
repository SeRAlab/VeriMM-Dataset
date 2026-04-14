`timescale 1ns/1ps

module aes_key_schedule_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg rst;
    wire [127:0] round_key;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_key_schedule dut (
        .clk(clk),
        .key(key),
        .rst(rst),
        .round_key(round_key)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            key = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Key Load (Round 0) - Zero Key", test_num);
            reset_dut();
            key = 128'h00000000000000000000000000000000;


            #1;



            check_outputs(128'h00000000000000000000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Round 1 Key Expansion - Zero Key", test_num);
            reset_dut();
            key = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h62636363626363636263636362636363);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Round 1 Key Expansion - FIPS-197 Key", test_num);
            reset_dut();
            key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'ha0fafe1788542cb123a239392a6c7605);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Round 2 Key Expansion - FIPS-197 Key", test_num);
            reset_dut();
            key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(128'hf2c295f27a96b94359348a7a7359fc7f);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Round 10 Key Expansion - FIPS-197 Key", test_num);
            reset_dut();
            key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(128'hd014f9a8c9ee2589e13f0cc8b6630ca6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_key_schedule Testbench");
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
        input [127:0] expected_round_key;
        begin
            if (expected_round_key === (expected_round_key ^ round_key ^ expected_round_key)) begin
                $display("PASS");
                $display("  Outputs: round_key=%h",
                         round_key);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: round_key=%h",
                         expected_round_key);
                $display("  Got:      round_key=%h",
                         round_key);
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
        $dumpvars(0,clk, key, rst, round_key);
    end

endmodule
