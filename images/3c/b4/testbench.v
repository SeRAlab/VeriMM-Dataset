`timescale 1ns/1ps

module hmac_sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [255:0] message;
    reg reset;
    reg start;
    wire done;
    wire [255:0] hmac_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac_sha256 dut (
        .clk(clk),
        .key(key),
        .message(message),
        .reset(reset),
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
            reset = 1;
            start = 0;
            key = 0;
            message = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All zeros", test_num);
            reset_dut();

            key = 256'h0;
            message = 256'h0;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 256'hf5164104085429188d3e90ec86a7d9b9a6b63d94186411425121406606001256);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Incremental key and message", test_num);
            reset_dut();

            key = 256'h0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20;
            message = 256'h48656c6c6f20576f726c642120484d4143205465737420566563746f722e2e2e;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 256'h824240974c0f2a715f2a13f64c6328373d52673d32832049e6f0b4d45d8196e8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Repeating bytes", test_num);
            reset_dut();

            key = 256'h4141414141414141414141414141414141414141414141414141414141414141;
            message = 256'h4242424242424242424242424242424242424242424242424242424242424242;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 256'h880775d7879e0f6f0590823c4a24f07a164b490417242d2a4506927c62d05779);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All bits high", test_num);
            reset_dut();

            key = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
            message = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 256'h045e0f52382c448d3c50965d137353f4a9f1a2e998e16912389d44c776412e8c);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac_sha256 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [255:0] expected_hmac_out;
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
        $dumpvars(0,clk, key, message, reset, start, done, hmac_out);
    end

endmodule
