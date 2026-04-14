`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg reset;
    reg start;
    wire [127:0] hash;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
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
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: All Zeros", test_num);
            reset_dut();

            message = 512'h0;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(ready == 1);
            @(posedge clk);



            #1;




            check_outputs(128'h70e43955d883f36a537f941160356c9e, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: All Ones", test_num);
            reset_dut();

            message = {16{32'hFFFFFFFF}};
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(128'he0998a46271a39641776985c7c800889, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Alternating Bits (55AA)", test_num);
            reset_dut();

            message = {32{16'h55AA}};
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(128'h36248310c14c538a1686641217e65893, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Incremental Bytes", test_num);
            reset_dut();

            for (i = 0; i < 64; i = i + 1) begin
                message[i*8 +: 8] = i[7:0];
            end

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(128'h27a3c3167f81f1220a597a7604473722, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Constant Mixed Pattern", test_num);
            reset_dut();

            message = 512'h6162636465666768696A6B6C6D6E6F707172737475767778797A303132333435363738394142434445464748494A4B4C4D4E4F505152535455565758595A2140;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(128'h9407137f6140654497e88970e5361093, 1'b1);
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
