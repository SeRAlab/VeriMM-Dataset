`timescale 1ns/1ps

module HMAC_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] message;
    reg reset;
    reg valid_in;
    wire [127:0] hmac_output;
    wire valid_out;

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
        .valid_in(valid_in),
        .hmac_output(hmac_output),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid_in = 0;
            key = 0;
            message = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros (Key=0, Msg=0)", test_num);
            reset_dut();
            key = 128'h0;
            message = 128'h0;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(message ^ XOR_CONST, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones (Key=All Fs, Msg=All Fs)", test_num);
            reset_dut();
            key = {128{1'b1}};
            message = {128{1'b1}};
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(message ^ XOR_CONST, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Arbitrary Msg, Zero Key", test_num);
            reset_dut();
            key = 128'h0;
            message = 128'hA5A5A5A5_B4B4B4B4_C3C3C3C3_D2D2D2D2;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(message ^ XOR_CONST, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Msg, Arbitrary Key", test_num);
            reset_dut();
            key = 128'hDEADBEEF_CAFEBABE_FEEDFACE_DEADC0DE;
            message = 128'h0;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(message ^ XOR_CONST, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Patterns", test_num);
            reset_dut();
            key = 128'h55555555_55555555_55555555_55555555;
            message = 128'hAAAAAAAAAAAAAAAA_AAAAAAAAAAAAAAAA;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(message ^ XOR_CONST, 1'b1);
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
        input [127:0] expected_hmac_output;
        input expected_valid_out;
        begin
            if (expected_hmac_output === (expected_hmac_output ^ hmac_output ^ expected_hmac_output) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: hmac_output=%h, valid_out=%b",
                         hmac_output, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hmac_output=%h, valid_out=%b",
                         expected_hmac_output, expected_valid_out);
                $display("  Got:      hmac_output=%h, valid_out=%b",
                         hmac_output, valid_out);
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
        $dumpvars(0,clk, key, message, reset, valid_in, hmac_output, valid_out);
    end

endmodule
