`timescale 1ns/1ps

module HMAC_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] key;
    reg [7:0] message;
    reg reset;
    reg start;
    wire [7:0] hmac_output;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    HMAC dut (
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
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            key = 8'h00;
            message = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(valid == 1);
            #1;

            check_outputs(8'h6A, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTest Case %0d: Max Key, Zero Message", test_num);
            key = 8'hFF;
            message = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(valid == 1);
            #1;

            check_outputs(8'h6A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTest Case %0d: Key 0xAA, Message 0x55", test_num);
            key = 8'hAA;
            message = 8'h55;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(valid == 1);
            #1;

            check_outputs(8'h3F, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTest Case %0d: Key 0x12, Message 0xFF", test_num);
            key = 8'h12;
            message = 8'hFF;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(valid == 1);
            #1;

            check_outputs(8'h95, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTest Case %0d: Arbitrary Pattern", test_num);
            key = 8'hC3;
            message = 8'h12;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(valid == 1);
            #1;

            check_outputs(8'h78, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("HMAC Testbench");
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
        input [7:0] expected_hmac_output;
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
