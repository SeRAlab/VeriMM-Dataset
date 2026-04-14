`timescale 1ns/1ps

module sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg rst;
    reg start;
    wire [255:0] hash;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256 dut (
        .clk(clk),
        .message(message),
        .rst(rst),
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
            rst = 1;
            start = 0;
            message = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Padded 'abc' message", test_num);
            reset_dut();


            message = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;

            @(posedge clk);
            #1;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            wait(ready === 1);
            @(posedge clk);
            #1;


            #1;



            check_outputs(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Padded empty string", test_num);
            reset_dut();

            message = 512'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;

            @(posedge clk);
            #1;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            wait(ready === 1);
            @(posedge clk);
            #1;


            #1;



            check_outputs(256'he3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All-zeros 512-bit block", test_num);
            reset_dut();

            message = 512'h0;

            @(posedge clk);
            #1;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            wait(ready === 1);
            @(posedge clk);
            #1;


            #1;



            check_outputs(256'hda5698be17b9b46962335799779fbeca8ce5d491c0d26243bafef94183c7d27e, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All-ones 512-bit block", test_num);
            reset_dut();

            message = {16{32'hFFFFFFFF}};

            @(posedge clk);
            #1;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            wait(ready === 1);
            @(posedge clk);
            #1;


            #1;



            check_outputs(256'hfbc36484985390e1f3c3a443a60a7d571897c8443916297314488b012423351d, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential processing test", test_num);


            reset_dut();
            message = 512'h0;
            @(posedge clk); #1; start = 1;
            @(posedge clk); #1; start = 0;
            wait(ready === 1);


            @(posedge clk);
            message = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
            @(posedge clk); #1; start = 1;
            @(posedge clk); #1; start = 0;
            wait(ready === 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256 Testbench");
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
        $dumpvars(0,clk, message, rst, start, hash, ready);
    end

endmodule
