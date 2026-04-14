`timescale 1ns/1ps

module HMAC_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] message;
    reg rst;
    reg start;
    wire done;
    wire [127:0] hmac_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    HMAC dut (
        .clk(clk),
        .key(key),
        .message(message),
        .rst(rst),
        .start(start),
        .done(done),
        .hmac_out(hmac_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        start = 0;
        key = 128'h0;
        message = 128'h0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: All Zeros", test_num);
        reset_dut();
        key = 128'h0;
        message = 128'h0;
        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(done);

        #1;


        check_outputs(1'b1, 128'h00000000000000000000000000000000);
        @(posedge clk);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: All Ones", test_num);
        reset_dut();
        key = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        message = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(done);
        #1;

        check_outputs(1'b1, 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        @(posedge clk);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Alternating Bits", test_num);
        reset_dut();
        key = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        message = 128'h55555555555555555555555555555555;
        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(done);
        #1;

        check_outputs(1'b1, 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA);
        @(posedge clk);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Zero Key, Random Message", test_num);
        reset_dut();
        key = 128'h0;
        message = 128'hDEADBEEFCAFEBABE1234567890ABCDEF;
        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(done);
        #1;

        check_outputs(1'b1, 128'hDEADBEEFCAFEBABE1234567890ABCDEF);
        @(posedge clk);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Random Key, Zero Message", test_num);
        reset_dut();
        key = 128'h0123456789ABCDEF0123456789ABCDEF;
        message = 128'h0;
        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(done);
        #1;

        check_outputs(1'b1, 128'h0123456789ABCDEF0123456789ABCDEF);
        @(posedge clk);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("HMAC Testbench");
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
        input expected_done;
        input [127:0] expected_hmac_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hmac_out === (expected_hmac_out ^ hmac_out ^ expected_hmac_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hmac_out=%h",
                         done, hmac_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hmac_out=%h",
                         expected_done, expected_hmac_out);
                $display("  Got:      done=%b, hmac_out=%h",
                         done, hmac_out);
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
        $dumpvars(0,clk, key, message, rst, start, done, hmac_out);
    end

endmodule
