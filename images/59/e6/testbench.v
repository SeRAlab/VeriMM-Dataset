`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg fsk_out;
    reg fsk_out_trigger;
    reg manual;
    reg sqwv;
    wire [44:0] decoded;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fsk_out(fsk_out),
        .fsk_out_trigger(fsk_out_trigger),
        .manual(manual),
        .sqwv(sqwv),
        .decoded(decoded),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        sqwv = 0;
        forever #5 sqwv = ~sqwv;
    end

        task reset_dut;

        begin
            manual = 1;
            fsk_out_trigger = 0;
            fsk_out = 0;
            repeat (5) @(posedge sqwv);
            manual = 0;
            repeat (5) @(posedge sqwv);
        end
        endtask
    task send_bit_pair;

        input bit_to_store;
        begin

            fsk_out = ~bit_to_store;
            fsk_out_trigger = 1;
            @(posedge sqwv);
            fsk_out_trigger = 0;
            repeat (2) @(posedge sqwv);


            fsk_out = bit_to_store;
            fsk_out_trigger = 1;
            @(posedge sqwv);
            fsk_out_trigger = 0;
            repeat (2) @(posedge sqwv);
        end
        endtask

    task testcase001;

        reg [44:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Full 45-bit sequence (Alternating 0101...)", test_num);
            reset_dut();
            pattern = 45'h0AAAAAAAAAAAA;

            for (i = 0; i < 45; i = i + 1) begin
                send_bit_pair(pattern[i]);
            end


            repeat (1) @(posedge sqwv);
            #1;

            check_outputs(pattern, 1'b1);
        end
        endtask

    task testcase002;

        reg [44:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Full 45-bit sequence (All Ones)", test_num);
            reset_dut();
            pattern = 45'h1FFFFFFFFFFFF;

            for (i = 0; i < 45; i = i + 1) begin
                send_bit_pair(1'b1);
            end

            repeat (1) @(posedge sqwv);
            #1;

            check_outputs(pattern, 1'b1);
        end
        endtask

    task testcase003;

        reg [44:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Full 45-bit sequence (All Zeros)", test_num);
            reset_dut();
            pattern = 45'h0000000000000;

            for (i = 0; i < 45; i = i + 1) begin
                send_bit_pair(1'b0);
            end

            repeat (1) @(posedge sqwv);
            #1;

            check_outputs(pattern, 1'b1);
        end
        endtask

    task testcase004;

        reg [44:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Manual reset during transmission", test_num);
            reset_dut();


            for (i = 0; i < 10; i = i + 1) begin
                send_bit_pair(1'b1);
            end


            manual = 1;
            repeat (2) @(posedge sqwv);
            manual = 0;
            repeat (2) @(posedge sqwv);


            pattern = 45'h123456789ABCD;
            for (i = 0; i < 45; i = i + 1) begin
                send_bit_pair(pattern[i]);
            end

            repeat (1) @(posedge sqwv);
            #1;

            check_outputs(pattern, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Verification of 'done' signal timing", test_num);
            reset_dut();


            for (i = 0; i < 44; i = i + 1) begin
                send_bit_pair(1'b1);
            end


            if (done === 1'b0) begin

                send_bit_pair(1'b1);
                repeat (1) @(posedge sqwv);
                #1;

                check_outputs(45'h1FFFFFFFFFFFF, 1'b1);
            end else begin
                $display("FAIL: done signal asserted too early at bit 44");
                fail_count = fail_count + 1;
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
        input [44:0] expected_decoded;
        input expected_done;
        begin
            if (expected_decoded === (expected_decoded ^ decoded ^ expected_decoded) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: decoded=%h, done=%b",
                         decoded, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded=%h, done=%b",
                         expected_decoded, expected_done);
                $display("  Got:      decoded=%h, done=%b",
                         decoded, done);
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
        $dumpvars(0,fsk_out, fsk_out_trigger, manual, sqwv, decoded, done);
    end

endmodule
