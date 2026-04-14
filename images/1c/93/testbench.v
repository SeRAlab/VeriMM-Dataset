`timescale 1ns/1ps

module hmac_sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [255:0] message;
    reg reset;
    reg start;
    wire [127:0] hmac_output;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac_sha256 dut (
        .clk(clk),
        .key(key),
        .message(message),
        .reset(reset),
        .start(start),
        .hmac_output(hmac_output),
        .valid(valid)
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
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Key and Message all zeros", test_num);
            reset_dut();

            key = 256'h0;
            message = 256'h0;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            wait(valid == 1);
            @(posedge clk);


            #1;



            check_outputs(128'hb613679a0814d9ec772f95d778c35fc5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Specific key and string message", test_num);
            reset_dut();


            key = {32{8'h01}};

            message = 256'h53616d706c65204d657373616765000000000000000000000000000000000000;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(valid == 1);
            @(posedge clk);

            #1;


            check_outputs(128'h16773539e76317b62e49c95d9e525a72, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating bit patterns", test_num);
            reset_dut();

            key = {32{8'haa}};
            message = {32{8'hdd}};

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(valid == 1);
            @(posedge clk);

            #1;


            check_outputs(128'h1860f4e138a0b0646c0a7620a2322305, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Short string message", test_num);
            reset_dut();

            key = {32{8'h0b}};

            message = 256'h4869205468657265000000000000000000000000000000000000000000000000;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(valid == 1);
            @(posedge clk);

            #1;


            check_outputs(128'h1004664883b281f6d35399580b2a59a7, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Fs", test_num);
            reset_dut();

            key = {256{1'b1}};
            message = {256{1'b1}};

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(valid == 1);
            @(posedge clk);

            #1;


            check_outputs(128'hf9995885c490a7860269074813587042, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac_sha256 Testbench");
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
        input [127:0] expected_hmac_output;
        input expected_valid;
        begin
            if (expected_hmac_output === (expected_hmac_output ^ hmac_output ^ expected_hmac_output) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: hmac_output=%h, valid=%b",
                         hmac_output, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hmac_output=%h, valid=%b",
                         expected_hmac_output, expected_valid);
                $display("  Got:      hmac_output=%h, valid=%b",
                         hmac_output, valid);
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
        $dumpvars(0,clk, key, message, reset, start, hmac_output, valid);
    end

endmodule
