`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg [511:0] block;
    reg clk;
    reg rst;
    reg start;
    wire done;
    wire [127:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .block(block),
        .clk(clk),
        .rst(rst),
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
        rst = 1;
        start = 0;
        block = 0;
        #20;
        @(posedge clk);
        rst = 0;
        @(posedge clk);
    end
        endtask
    task pulse_start;

    begin
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
    end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: MD5 Empty String", test_num);
        reset_dut();


        block = 512'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;

        pulse_start();


        wait(done);
        @(posedge clk);


        #1;



        check_outputs(1'b1, 128'hd41d8cd98f00b204e9800998ecf8427e);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: MD5 'abc'", test_num);
        reset_dut();

        block = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001800000000000000;

        pulse_start();

        wait(done);
        @(posedge clk);


        #1;



        check_outputs(1'b1, 128'h900150983cd24fb0d6963f7d28e17f72);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: MD5 'message digest'", test_num);
        reset_dut();


        block = 512'h6d657373616765206469676573748000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000000000000;

        pulse_start();

        wait(done);
        @(posedge clk);


        #1;



        check_outputs(1'b1, 128'hf96b697d7cb7938d525a2f31aaf161d0);
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
        $dumpvars(0,block, clk, rst, start, done, hash);
    end

endmodule
