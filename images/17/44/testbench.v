`timescale 1ns/1ps

module sha256_simple_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message_in;
    reg reset;
    wire [255:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_simple dut (
        .clk(clk),
        .message_in(message_in),
        .reset(reset),
        .hash_out(hash_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            message_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: All Zeros");
            reset_dut();
            message_in = 512'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(256'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: All Ones");
            reset_dut();
            message_in = {512{1'b1}};
            @(posedge clk);
            #1;
            #1;

            check_outputs({256{1'b1}});
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Pattern Check - High Bits");
            reset_dut();

            message_in = {256'hDEADBEEF_CAFEBABE_FEEDFACE_CAFED00D_12345678_9ABCDEF0_0FEDCBA9_87654321, 256'h0};
            @(posedge clk);
            #1;
            #1;

            check_outputs(256'hDEADBEEF_CAFEBABE_FEEDFACE_CAFED00D_12345678_9ABCDEF0_0FEDCBA9_87654321);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Pattern Check - Low Bits Ignored");
            reset_dut();

            message_in = {256'h0, 256'hDEADBEEF_CAFEBABE_FEEDFACE_CAFED00D_12345678_9ABCDEF0_0FEDCBA9_87654321};
            @(posedge clk);
            #1;
            #1;

            check_outputs(256'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Alternating Pattern");
            reset_dut();
            message_in = {512{2'b10}};
            @(posedge clk);
            #1;
            #1;

            check_outputs({256{2'b10}});
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Data Update Check");
            reset_dut();
            message_in = {256'h1111_2222_3333_4444_5555_6666_7777_8888_9999_0000_AAAA_BBBB_CCCC_DDDD_EEEE_FFFF, 256'h0};
            @(posedge clk);
            #1;
            #1;

            check_outputs(256'h1111_2222_3333_4444_5555_6666_7777_8888_9999_0000_AAAA_BBBB_CCCC_DDDD_EEEE_FFFF);


            message_in = {256'hFFFF_EEEE_DDDD_CCCC_BBBB_AAAA_0000_9999_8888_7777_6666_5555_4444_3333_2222_1111, 256'h0};
            @(posedge clk);
            #1;
            #1;

            check_outputs(256'hFFFF_EEEE_DDDD_CCCC_BBBB_AAAA_0000_9999_8888_7777_6666_5555_4444_3333_2222_1111);
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
        input [255:0] expected_hash_out;
        begin
            if (expected_hash_out === (expected_hash_out ^ hash_out ^ expected_hash_out)) begin
                $display("PASS");
                $display("  Outputs: hash_out=%h",
                         hash_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_out=%h",
                         expected_hash_out);
                $display("  Got:      hash_out=%h",
                         hash_out);
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
        $dumpvars(0,clk, message_in, reset, hash_out);
    end

endmodule
