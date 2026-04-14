`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg kClock;
    reg kData;
    wire [9:0] LEDR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .kClock(kClock),
        .kData(kData),
        .LEDR(LEDR)
    );

    // Clock generation (10ns period)
    initial begin
        kClock = 0;
        forever #5 kClock = ~kClock;
    end

        task reset_dut;

        begin
            kClock = 1;
            kData = 1;
            #50;
        end
        endtask
    task send_bit;

        input bit_val;
        begin
            kData = bit_val;
            #10;
            kClock = 0;
            #10;
            kClock = 1;
            #10;
        end
        endtask

    task send_11bits;

        input [10:0] full_seq;
        integer i;
        begin
            for (i = 10; i >= 0; i = i - 1) begin
                send_bit(full_seq[i]);
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Sending 8'hA5 followed by 3 padding bits", test_num);
            reset_dut();


            send_11bits({8'hA5, 3'b101});
            #20;
            #1;

            check_outputs(10'h0A5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Sending 8'h3C followed by 3 padding bits", test_num);
            reset_dut();


            send_11bits({8'h3C, 3'b000});
            #20;
            #1;

            check_outputs(10'h03C);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Sending 8'hFF followed by 3 padding bits", test_num);
            reset_dut();

            send_11bits({8'hFF, 3'b010});
            #20;
            #1;

            check_outputs(10'h0FF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Sending 8'h00 followed by 3 padding bits", test_num);
            reset_dut();

            send_11bits({8'h00, 3'b111});
            #20;
            #1;

            check_outputs(10'h000);
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
        input [9:0] expected_LEDR;
        begin
            if (expected_LEDR === (expected_LEDR ^ LEDR ^ expected_LEDR)) begin
                $display("PASS");
                $display("  Outputs: LEDR=%h",
                         LEDR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDR=%h",
                         expected_LEDR);
                $display("  Got:      LEDR=%h",
                         LEDR);
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
        $dumpvars(0,kClock, kData, LEDR);
    end

endmodule
