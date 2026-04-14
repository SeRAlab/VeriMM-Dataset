`timescale 1ns/1ps

module sha256_simple_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg reset;
    reg start;
    wire [255:0] hash;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_simple dut (
        .clk(clk),
        .message(message),
        .reset(reset),
        .start(start),
        .hash(hash),
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
            message = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Hash of 'abc' (512-bit padded block)", test_num);
            reset_dut();


            message = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;

            start = 1;
            @(posedge clk);
            start = 0;


            while (!ready) @(posedge clk);


            #1;



            check_outputs(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Hash of empty message (512-bit padded block)", test_num);
            reset_dut();


            message = 512'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;

            start = 1;
            @(posedge clk);
            start = 0;

            while (!ready) @(posedge clk);


            #1;



            check_outputs(256'he3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Hash of 512-bit block of all zeros", test_num);
            reset_dut();

            message = 512'h0;

            start = 1;
            @(posedge clk);
            start = 0;

            while (!ready) @(posedge clk);


            #1;



            check_outputs(256'hda5698d520e74f3885f4035415750059e74ce9a7d363297a731e0f09a8079532, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Hash of 512-bit block of all ones", test_num);
            reset_dut();

            message = {512{1'b1}};

            start = 1;
            @(posedge clk);
            start = 0;

            while (!ready) @(posedge clk);


            #1;



            check_outputs(256'h7986047392182280d4681329c32274971c66743c33eb2e5d933390c5299445f1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256_simple Testbench");
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
        input [255:0] expected_hash;
        input expected_ready;
        begin
            if (expected_hash === (expected_hash ^ hash ^ expected_hash) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: hash=%h, ready=%b",
                         hash, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h, ready=%b",
                         expected_hash, expected_ready);
                $display("  Got:      hash=%h, ready=%b",
                         hash, ready);
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
        $dumpvars(0,clk, message, reset, start, hash, ready);
    end

endmodule
