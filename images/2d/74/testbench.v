`timescale 1ns/1ps

module HMAC_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] message;
    reg reset;
    reg start;
    wire done;
    wire [127:0] mac;

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
        .done(done),
        .mac(mac)
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
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task run_hmac;

        input [127:0] in_key;
        input [127:0] in_msg;
        begin
            key = in_key;
            message = in_msg;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTest Case %03d: All Zeros", test_num);

            run_hmac(128'h0, 128'h0);
            #1;

            check_outputs(1'b1, 128'h6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTest Case %03d: Key is IPAD, Message is All Ones", test_num);

            run_hmac(IPAD, {128{1'b1}});
            #1;

            check_outputs(1'b1, 128'h95959595959595959595959595959595);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTest Case %03d: All Ones Key, Zero Message", test_num);

            run_hmac({128{1'b1}}, 128'h0);
            #1;

            check_outputs(1'b1, 128'h6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTest Case %03d: Arbitrary Hex Patterns", test_num);

            run_hmac(128'hDEADBEEFDEADBEEFDEADBEEFDEADBEEF, 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA);
            #1;

            check_outputs(1'b1, 128'hC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0);
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
        input [127:0] expected_mac;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_mac === (expected_mac ^ mac ^ expected_mac)) begin
                $display("PASS");
                $display("  Outputs: done=%b, mac=%h",
                         done, mac);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, mac=%h",
                         expected_done, expected_mac);
                $display("  Got:      done=%b, mac=%h",
                         done, mac);
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
        $dumpvars(0,clk, key, message, reset, start, done, mac);
    end

endmodule
