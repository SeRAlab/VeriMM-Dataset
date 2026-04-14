`timescale 1ns/1ps

module HMAC_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] key;
    reg [63:0] message;
    reg reset;
    reg start;
    wire done;
    wire [127:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    HMAC dut (
        .clk(clk),
        .key(key),
        .message(message),
        .reset(reset),
        .start(start),
        .done(done),
        .hash(hash)
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

        reg [63:0] expected_outer;
        begin
            $display("\nTest Case 001: All Zeros");
            reset_dut();
            test_num = 1;
            key = 64'h0;
            message = 64'h0;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);

            expected_outer = 64'h6A6A6A6A6A6A6A6A ^ message;
            #1;

            check_outputs(1'b1, {expected_outer, ~expected_outer});
        end
        endtask

    task testcase002;

        reg [63:0] expected_outer;
        begin
            $display("\nTest Case 002: All Ones Message");
            reset_dut();
            test_num = 2;
            key = 64'h0;
            message = 64'hFFFFFFFFFFFFFFFF;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);

            expected_outer = 64'h6A6A6A6A6A6A6A6A ^ message;
            #1;

            check_outputs(1'b1, {expected_outer, ~expected_outer});
        end
        endtask

    task testcase003;

        reg [63:0] expected_outer;
        begin
            $display("\nTest Case 003: Alternating Bits");
            reset_dut();
            test_num = 3;
            key = 64'hAAAAAAAAAAAAAAAA;
            message = 64'h5555555555555555;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);

            expected_outer = 64'h6A6A6A6A6A6A6A6A ^ message;
            #1;

            check_outputs(1'b1, {expected_outer, ~expected_outer});
        end
        endtask

    task testcase004;

        reg [63:0] expected_outer;
        begin
            $display("\nTest Case 004: Random Hex Pattern");
            reset_dut();
            test_num = 4;
            key = 64'hDEADBEEFCAFEBABE;
            message = 64'h0123456789ABCDEF;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);

            expected_outer = 64'h6A6A6A6A6A6A6A6A ^ message;
            #1;

            check_outputs(1'b1, {expected_outer, ~expected_outer});
        end
        endtask

    task testcase005;

        reg [63:0] expected_outer;
        begin
            $display("\nTest Case 005: Key Sensitivity");
            reset_dut();
            test_num = 5;
            key = 64'h13579BDF02468ACE;
            message = 64'h0123456789ABCDEF;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);

            expected_outer = 64'h6A6A6A6A6A6A6A6A ^ message;
            #1;

            check_outputs(1'b1, {expected_outer, ~expected_outer});
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
        input [127:0] expected_hash;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hash === (expected_hash ^ hash ^ expected_hash)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hash=%h",
                         done, hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hash=%h",
                         expected_done, expected_hash);
                $display("  Got:      done=%b, hash=%h",
                         done, hash);
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
        $dumpvars(0,clk, key, message, reset, start, done, hash);
    end

endmodule
