`timescale 1ns/1ps

module hmac_sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [255:0] message;
    reg reset;
    reg start;
    wire [255:0] hash_output;
    wire ready;

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
        .hash_output(hash_output),
        .ready(ready)
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
            test_num = 1;
            reset_dut();
            key = 256'h0;
            message = 256'h0;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(ready == 1);
            @(posedge clk);


            #1;



            check_outputs(256'hf310f03407e7c8ec3f84393641a967c13483984e7208d32d0891d4d12eb4a05f, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            key     = 256'h0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20;
            message = 256'h6162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f80;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ready == 1);
            @(posedge clk);


            #1;



            check_outputs(256'h3506169c9b74051a8d438914c670b33235d1f868f7f185799a9a3b2b8c9d0922, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            key     = {256{1'b1}};
            message = 256'h0;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(256'h9945030426d15682187766099190289f816c808f9a94469733c7f9502941011b, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            key     = 256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            message = 256'h5555555555555555555555555555555555555555555555555555555555555555;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(256'h809d437e3d9354972552803b98c39d89233634024b42337e738c6d17e0892c5e, 1'b1);
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
        input [255:0] expected_hash_output;
        input expected_ready;
        begin
            if (expected_hash_output === (expected_hash_output ^ hash_output ^ expected_hash_output) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: hash_output=%h, ready=%b",
                         hash_output, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_output=%h, ready=%b",
                         expected_hash_output, expected_ready);
                $display("  Got:      hash_output=%h, ready=%b",
                         hash_output, ready);
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
        $dumpvars(0,clk, key, message, reset, start, hash_output, ready);
    end

endmodule
