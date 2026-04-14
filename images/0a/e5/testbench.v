`timescale 1ns/1ps

module hmac_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [63:0] key;
    reg [63:0] message;
    reg reset;
    wire done;
    wire [63:0] hmac_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac dut (
        .clk(clk),
        .enable(enable),
        .key(key),
        .message(message),
        .reset(reset),
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
            reset = 1;
            enable = 0;
            key = 0;
            message = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Identity with Zero Key", test_num);
            reset_dut();
            key = 64'h0000000000000000;
            message = 64'hABCDEFA012345678;
            enable = 1;
            @(posedge clk);
            enable = 0;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 64'hABCDEFA012345678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: All Bits Set (Result should be 0)", test_num);
            reset_dut();
            key = 64'hFFFFFFFFFFFFFFFF;
            message = 64'hFFFFFFFFFFFFFFFF;
            enable = 1;
            @(posedge clk);
            enable = 0;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 64'h0000000000000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Alternating Bit Patterns", test_num);
            reset_dut();
            key = 64'hAAAAAAAAAAAAAAAA;
            message = 64'h5555555555555555;
            enable = 1;
            @(posedge clk);
            enable = 0;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Complementary Inputs", test_num);
            reset_dut();
            key = 64'h0123456789ABCDEF;
            message = 64'hFEDCBA9876543210;
            enable = 1;
            @(posedge clk);
            enable = 0;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Arbitrary Data Verification", test_num);
            reset_dut();
            key = 64'h12345678DEADBEEF;
            message = 64'h87654321CAFEBABE;
            enable = 1;
            @(posedge clk);
            enable = 0;


            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 64'h9551155914530451);
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
        input [63:0] expected_hmac_out;
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
        $dumpvars(0,clk, enable, key, message, reset, done, hmac_out);
    end

endmodule
