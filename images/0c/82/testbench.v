`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] message;
    reg rst;
    wire [127:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
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
            message = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = 128'h0 (All Zeros)", test_num);
            reset_dut();
            message = 128'h0;

            repeat(100) @(posedge clk);
            #1;

            check_outputs(128'hc9a2c3886f4a3e9c60010901e1d8849b);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = 128'hFFFF...FFFF (All Ones)", test_num);
            reset_dut();
            message = {4{32'hFFFFFFFF}};
            repeat(100) @(posedge clk);
            #1;

            check_outputs(128'h07198a2879555627725914620a28f804);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = 'abcdefghijklmnop'", test_num);
            reset_dut();
            message = 128'h6162636465666768696a6b6c6d6e6f70;
            repeat(100) @(posedge clk);
            #1;

            check_outputs(128'hc31b312a02497675f68c347d4834e9e1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = 128'hA5A5... (Alternating Bits)", test_num);
            reset_dut();
            message = {8{16'hA5A5}};
            repeat(100) @(posedge clk);
            #1;

            check_outputs(128'h9f1680968940608927894a4c515a2082);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = '1234567890123456'", test_num);
            reset_dut();
            message = 128'h31323334353637383930313233343536;
            repeat(100) @(posedge clk);
            #1;

            check_outputs(128'hf8964724a87c30f9bd373d3206013063);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_hash Testbench");
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
        input [127:0] expected_hash;
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
        $dumpvars(0,clk, message, rst, hash);
    end

endmodule
