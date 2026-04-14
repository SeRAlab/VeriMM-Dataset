`timescale 1ns/1ps

module hmac_sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] message;
    reg reset;
    reg start;
    wire [255:0] hmac_out;
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
        .hmac_out(hmac_out),
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
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Test Case %0d: All Zeros...", test_num);

            key = 128'h00000000000000000000000000000000;
            message = 128'h00000000000000000000000000000000;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(valid);

            #1;


            check_outputs(256'h8ba7453006d641604a378893f497746244cf53d53671249b6574f280a808064a, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Test Case %0d: Patterned Key/Message...", test_num);

            key = 128'h0102030405060708090a0b0c0d0e0f10;
            message = 128'h48656c6c6f20576f726c642121212121;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(valid);

            #1;


            check_outputs(256'h95c73950f612502641ec9b3f305c0888915e714157d079313a5165d7585ed64c, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Test Case %0d: All Ones...", test_num);

            key = 128'hffffffffffffffffffffffffffffffff;
            message = 128'hffffffffffffffffffffffffffffffff;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(valid);

            #1;


            check_outputs(256'h99e000851f50337f71109a9307f07e59c231705668b553e1d520cf819f24345d, 1'b1);
            @(posedge clk);
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
        input [255:0] expected_hmac_out;
        input expected_valid;
        begin
            if (expected_hmac_out === (expected_hmac_out ^ hmac_out ^ expected_hmac_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: hmac_out=%h, valid=%b",
                         hmac_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hmac_out=%h, valid=%b",
                         expected_hmac_out, expected_valid);
                $display("  Got:      hmac_out=%h, valid=%b",
                         hmac_out, valid);
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
        $dumpvars(0,clk, key, message, reset, start, hmac_out, valid);
    end

endmodule
