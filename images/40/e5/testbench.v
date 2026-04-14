`timescale 1ns/1ps

module hmac_sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [255:0] message;
    reg reset;
    reg start;
    wire done;
    wire [255:0] hmac_output;

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
        .hmac_output(hmac_output)
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
        key = 256'h0;
        message = 256'h0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Zero Key and Zero Message", test_num);
        reset_dut();

        key     = 256'h0000000000000000000000000000000000000000000000000000000000000000;
        message = 256'h0000000000000000000000000000000000000000000000000000000000000000;

        start = 1;
        @(posedge clk);
        #1 start = 0;


        wait(done);
        @(posedge clk);


        #1;



        check_outputs(1'b1, 256'hb613679a0814d9ec772f95d778c309185b0c7d54396c29419b7015599045ff10);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Incremental Key and Message", test_num);
        reset_dut();

        key     = 256'h0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20;
        message = 256'h0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20;

        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(done);
        @(posedge clk);


        #1;



        check_outputs(1'b1, 256'h996962070f6e520032906806e594d75d25243857e84a29a2432658145e656096);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: All F's Key and Message", test_num);
        reset_dut();

        key     = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        message = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(done);
        @(posedge clk);

        #1;


        check_outputs(1'b1, 256'ha21b373466184852e987f2255018a3852033c4f74d9e033924f0c0556551b8c0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Known String Pattern", test_num);
        reset_dut();

        key     = 256'h4a65666500000000000000000000000000000000000000000000000000000000;
        message = 256'h7768617420646f2079612077616e7420666f72206e6f7468696e673f00000000;

        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(done);
        @(posedge clk);

        #1;


        check_outputs(1'b1, 256'h0cc98227b872412e8b0a9b6f849e75553e18a99a7796d195c643912192131376);
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
        input [255:0] expected_hmac_output;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hmac_output === (expected_hmac_output ^ hmac_output ^ expected_hmac_output)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hmac_output=%h",
                         done, hmac_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hmac_output=%h",
                         expected_done, expected_hmac_output);
                $display("  Got:      done=%b, hmac_output=%h",
                         done, hmac_output);
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
        $dumpvars(0,clk, key, message, reset, start, done, hmac_output);
    end

endmodule
