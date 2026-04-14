`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] msg;
    reg rst;
    wire [127:0] hash;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .msg(msg),
        .rst(rst),
        .hash(hash),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input 'a' (0x61)", test_num);
            msg = 8'h61;
            rst = 1;
            #20;
            rst = 0;

            wait(valid === 1'b1);
            #1;

            check_outputs(128'h0cc175b9c0f1b6a831c399e269772661, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input 'b' (0x62)", test_num);
            msg = 8'h62;
            rst = 1;
            #20;
            rst = 0;
            wait(valid === 1'b1);
            #1;

            check_outputs(128'h92eb5ffee6ae2fec3ad71c777531578f, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input 'A' (0x41)", test_num);
            msg = 8'h41;
            rst = 1;
            #20;
            rst = 0;
            wait(valid === 1'b1);
            #1;

            check_outputs(128'h7fc56270e7a70fa81a5935b72eacbe29, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input '1' (0x31)", test_num);
            msg = 8'h31;
            rst = 1;
            #20;
            rst = 0;
            wait(valid === 1'b1);
            #1;

            check_outputs(128'hc4ca4238a0b923820dcc509a6f75849b, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input Null (0x00)", test_num);
            msg = 8'h00;
            rst = 1;
            #20;
            rst = 0;
            wait(valid === 1'b1);
            #1;

            check_outputs(128'h93b885adfe0da089cdf634904fd59f71, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input 0xFF", test_num);
            msg = 8'hFF;
            rst = 1;
            #20;
            rst = 0;
            wait(valid === 1'b1);
            #1;

            check_outputs(128'h6e12e75e9f899a70014b219f56385d38, 1'b1);
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
        input [127:0] expected_hash;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hash === (expected_hash ^ hash ^ expected_hash) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: hash=%h, valid=%b",
                         hash, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h, valid=%b",
                         expected_hash, expected_valid);
                $display("  Got:      hash=%h, valid=%b",
                         hash, valid);
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

endmodule
