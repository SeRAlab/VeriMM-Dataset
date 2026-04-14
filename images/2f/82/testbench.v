`timescale 1ns/1ps

module sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg reset;
    reg valid;
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
        .reset(reset),
        .valid(valid),
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
        valid = 0;
        message = 0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nRunning Test Case %0d: Padded 'abc' Block", test_num);
        reset_dut();

        message = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
        valid = 1;
        @(posedge clk);
        #1 valid = 0;


        wait(ready === 1);
        @(posedge clk);
        #1;

        #1;


        check_outputs(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nRunning Test Case %0d: All-Zeroes Block", test_num);
        reset_dut();

        message = 512'h0;
        valid = 1;
        @(posedge clk);
        #1 valid = 0;

        wait(ready === 1);
        @(posedge clk);
        #1;

        #1;


        check_outputs(256'hda5698be17b9b46962335799779fbeca8ce5d491c0d26243bafef94183c8574b, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nRunning Test Case %0d: All-Ones Block", test_num);
        reset_dut();

        message = {16{32'hFFFFFFFF}};
        valid = 1;
        @(posedge clk);
        #1 valid = 0;

        wait(ready === 1);
        @(posedge clk);
        #1;

        #1;


        check_outputs(256'h0b809d3b843f545465e6d63335e263c9b468514a60f64c125df8f5f624468f7b, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nRunning Test Case %0d: 64 Bytes of 'a'", test_num);
        reset_dut();

        message = {64{8'h61}};
        valid = 1;
        @(posedge clk);
        #1 valid = 0;

        wait(ready === 1);
        @(posedge clk);
        #1;

        #1;


        check_outputs(256'h9069735d1859c720610f60c87895e691763172085376044714e820a232230058, 1);
    end
        endtask

    task testcase005;

    reg [511:0] pattern;
    integer i;
    begin
        test_num = test_num + 1;
        $display("\nRunning Test Case %0d: Incremental Pattern", test_num);
        reset_dut();

        for (i = 0; i < 64; i = i + 1) begin
            pattern[i*8 +: 8] = i[7:0];
        end

        message = pattern;
        valid = 1;
        @(posedge clk);
        #1 valid = 0;

        wait(ready === 1);
        @(posedge clk);
        #1;




        #1;





        check_outputs(256'h72c0c00829875e533c3751790604218a598c19b28a1c97f1f00889c6291a13e5, 1);
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
        $dumpvars(0,clk, message, reset, valid, hash, ready);
    end

endmodule
