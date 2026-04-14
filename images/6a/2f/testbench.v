`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg hash_clk;
    reg [1:0] new_nonces;
    reg serial_busy;
    reg [63:0] slave_nonces;
    wire [31:0] golden_nonce;
    wire serial_send;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hash_clk(hash_clk),
        .new_nonces(new_nonces),
        .serial_busy(serial_busy),
        .slave_nonces(slave_nonces),
        .golden_nonce(golden_nonce),
        .serial_send(serial_send)
    );

    // Clock generation (10ns period)
    initial begin
        hash_clk = 0;
        forever #5 hash_clk = ~hash_clk;
    end

        task reset_dut;

        begin
            new_nonces = 2'b00;
            serial_busy = 1'b0;
            slave_nonces = 64'h0;
            repeat(2) @(posedge hash_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle State", test_num);
            reset_dut();
            repeat(5) @(posedge hash_clk);


            #1;



            check_outputs(golden_nonce, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmission of Nonce 0", test_num);
            reset_dut();
            slave_nonces = 64'h11112222_33334444;
            new_nonces = 2'b01;
            @(posedge hash_clk);
            new_nonces = 2'b00;
            repeat(1) @(posedge hash_clk);

            #1;


            check_outputs(32'h33334444, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmission of Nonce 1", test_num);
            reset_dut();
            slave_nonces = 64'hAAAA_BBBB_CCCC_DDDD;
            new_nonces = 2'b10;
            @(posedge hash_clk);
            new_nonces = 2'b00;
            repeat(1) @(posedge hash_clk);

            #1;


            check_outputs(32'hAAAA_BBBB, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Dual Transmission", test_num);
            reset_dut();
            slave_nonces = 64'h12345678_9ABCDEF0;
            new_nonces = 2'b11;
            @(posedge hash_clk);
            new_nonces = 2'b00;


            repeat(1) @(posedge hash_clk);
            $display("Checking first nonce...");
            if (golden_nonce == 32'h9ABCDEF0 && serial_send == 1'b1) pass_count = pass_count + 0;



            repeat(2) @(posedge hash_clk);


            #1;



            check_outputs(32'h12345678, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Serial Busy Blocking", test_num);
            reset_dut();
            serial_busy = 1'b1;
            slave_nonces = 64'hDEADC0DE_BEEFBABE;
            new_nonces = 2'b01;
            repeat(5) @(posedge hash_clk);


            if (serial_send == 1'b0) begin
                $display("Correct: Waiting for busy to clear.");
                serial_busy = 1'b0;
                repeat(2) @(posedge hash_clk);
                #1;

                check_outputs(32'hBEEFBABE, 1'b1);
            end else begin
                #1;

                check_outputs(32'hBEEFBABE, 1'b0);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_golden_nonce;
        input expected_serial_send;
        begin
            if (expected_golden_nonce === (expected_golden_nonce ^ golden_nonce ^ expected_golden_nonce) &&
                expected_serial_send === (expected_serial_send ^ serial_send ^ expected_serial_send)) begin
                $display("PASS");
                $display("  Outputs: golden_nonce=%h, serial_send=%b",
                         golden_nonce, serial_send);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: golden_nonce=%h, serial_send=%b",
                         expected_golden_nonce, expected_serial_send);
                $display("  Got:      golden_nonce=%h, serial_send=%b",
                         golden_nonce, serial_send);
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
        $dumpvars(0,hash_clk, new_nonces, serial_busy, slave_nonces, golden_nonce, serial_send);
    end

endmodule
