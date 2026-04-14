`timescale 1ns/1ps

module sha256_block_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg rst;
    reg valid;
    wire [255:0] hash;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_block_processor dut (
        .clk(clk),
        .message(message),
        .rst(rst),
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
            rst = 1;
            valid = 0;
            message = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 512-bit All Zeros Block", test_num);
            reset_dut();

            message = 512'h0;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;


            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(256'hda5698be17b9b46962335799779fbeca8ce5d491c0d26243bafef94183719048, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pre-padded 'abc' Message", test_num);
            reset_dut();

            message = {24'h616263, 8'h80, 416'h0, 64'h18};
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 512-bit All Ones Block", test_num);
            reset_dut();

            message = {16{32'hffffffff}};
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(256'h62c8033230a446c651871e42766f7f63110531536b0058b292e92c4883478954, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pre-padded Empty Message", test_num);
            reset_dut();

            message = {8'h80, 440'h0, 64'h0};
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(256'he3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256_block_processor Testbench");
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
        $dumpvars(0,clk, message, rst, valid, hash, ready);
    end

endmodule
