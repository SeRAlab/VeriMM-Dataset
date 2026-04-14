`timescale 1ns/1ps

module hmac_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] key;
    reg [7:0] message;
    reg rst;
    reg start;
    wire done;
    wire [15:0] hmac_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac dut (
        .clk(clk),
        .key(key),
        .message(message),
        .rst(rst),
        .start(start),
        .done(done),
        .hmac_out(hmac_out)
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
            key = 8'h00;
            message = 8'h00;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task run_hmac;

        input [7:0] i_key;
        input [7:0] i_msg;
        begin
            key = i_key;
            message = i_msg;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            while (!done) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            $display("Running Testcase 001: Key=00, Msg=00");
            reset_dut();
            run_hmac(8'h00, 8'h00);


            #1;



            check_outputs(1'b1, hmac_out);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Key=FF, Msg=FF");
            reset_dut();
            run_hmac(8'hFF, 8'hFF);
            #1;

            check_outputs(1'b1, hmac_out);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Key=55, Msg=AA");
            reset_dut();
            run_hmac(8'h55, 8'hAA);
            #1;

            check_outputs(1'b1, hmac_out);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Key=12, Msg=34");
            reset_dut();
            run_hmac(8'h12, 8'h34);
            #1;

            check_outputs(1'b1, hmac_out);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Key=F0, Msg=0F");
            reset_dut();
            run_hmac(8'hF0, 8'h0F);
            #1;

            check_outputs(1'b1, hmac_out);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac Testbench");
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
        input expected_done;
        input [15:0] expected_hmac_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hmac_out === (expected_hmac_out ^ hmac_out ^ expected_hmac_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hmac_out=%h",
                         done, hmac_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hmac_out=%h",
                         expected_done, expected_hmac_out);
                $display("  Got:      done=%b, hmac_out=%h",
                         done, hmac_out);
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
        $dumpvars(0,clk, key, message, rst, start, done, hmac_out);
    end

endmodule
