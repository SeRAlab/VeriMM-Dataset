`timescale 1ns/1ps

module hmac_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] key;
    reg [63:0] message;
    reg rst;
    wire [63:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac_generator dut (
        .clk(clk),
        .key(key),
        .message(message),
        .rst(rst),
        .hash(hash)
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
        message = 0;
        @(posedge clk);
        #2 rst = 0;

        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Zeros", test_num);
        reset_dut();
        key = 64'h0;
        message = 64'h0;
        @(posedge clk);
        #1 #1;
 check_outputs(calculate_expected(key, message));
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Message Only (Key=0)", test_num);
        reset_dut();
        key = 64'h0;
        message = 64'hABCDEFFF12345678;
        @(posedge clk);
        #1 #1;
 check_outputs(calculate_expected(key, message));
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Key Only (Message=0)", test_num);
        reset_dut();
        key = 64'hFFFFFFFFFFFFFFFF;
        message = 64'h0;
        @(posedge clk);
        #1 #1;
 check_outputs(calculate_expected(key, message));
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Complementary Inputs (Resulting in All Ones XOR)", test_num);
        reset_dut();
        key = 64'hAAAAAAAAAAAAAAAA;
        message = 64'h5555555555555555;
        @(posedge clk);
        #1 #1;
 check_outputs(calculate_expected(key, message));
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random Data Pattern", test_num);
        reset_dut();
        key = 64'h13579BDF02468ACE;
        message = 64'hECA86420FDB97531;
        @(posedge clk);
        #1 #1;
 check_outputs(calculate_expected(key, message));
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac_generator Testbench");
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
        input [63:0] expected_hash;
        begin
            if (expected_hash === (expected_hash ^ hash ^ expected_hash)) begin
                $display("PASS");
                $display("  Outputs: hash=%h",
                         hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h",
                         expected_hash);
                $display("  Got:      hash=%h",
                         hash);
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
        $dumpvars(0,clk, key, message, rst, hash);
    end

endmodule
