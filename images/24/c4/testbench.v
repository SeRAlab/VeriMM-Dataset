`timescale 1ns/1ps

module HMAC_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] key;
    reg [3:0] message;
    reg rst;
    reg valid_in;
    wire [3:0] hmac_out;
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
        .rst(rst),
        .valid_in(valid_in),
        .hmac_out(hmac_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid_in = 0;
            key = 4'h0;
            message = 4'h0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Basic operation (Zeros) - Key: 0, Msg: 0", test_num);
            key = 4'h0;
            message = 4'h0;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;


            while (!valid_out) @(posedge clk);
            #1;


            #1;



            check_outputs(4'h6, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Max values - Key: F, Msg: F", test_num);
            key = 4'hF;
            message = 4'hF;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            while (!valid_out) @(posedge clk);
            #1;


            #1;



            check_outputs(4'h9, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Key cancellation check - Key: A, Msg: 5", test_num);
            key = 4'hA;
            message = 4'h5;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            while (!valid_out) @(posedge clk);
            #1;


            #1;



            check_outputs(4'h3, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Arbitrary pattern - Key: 3, Msg: A", test_num);
            key = 4'h3;
            message = 4'hA;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            while (!valid_out) @(posedge clk);
            #1;


            #1;



            check_outputs(4'hC, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Result zero check - Key: 1, Msg: 6", test_num);
            key = 4'h1;
            message = 4'h6;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            while (!valid_out) @(posedge clk);
            #1;


            #1;



            check_outputs(4'h0, 1'b1);
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
        input [3:0] expected_hmac_out;
        input expected_valid_out;
        begin
            if (expected_hmac_out === (expected_hmac_out ^ hmac_out ^ expected_hmac_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: hmac_out=%h, valid_out=%b",
                         hmac_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hmac_out=%h, valid_out=%b",
                         expected_hmac_out, expected_valid_out);
                $display("  Got:      hmac_out=%h, valid_out=%b",
                         hmac_out, valid_out);
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
        $dumpvars(0,clk, key, message, rst, valid_in, hmac_out, valid_out);
    end

endmodule
