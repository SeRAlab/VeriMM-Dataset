`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] delay;
    reg in;
    reg reset;
    reg sync;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .delay(delay),
        .in(in),
        .reset(reset),
        .sync(sync),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        reset = 1;
        sync = 0;
        in = 0;
        delay = 0;
        @(negedge clk);
        reset = 0;
        #1;
    end
        endtask
    task drive_bit;

        input bit_in;
        input sync_val;
        begin
            @(negedge clk);
            in = bit_in;
            sync = sync_val;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Delay 0 Check", test_num);
        reset_dut();
        delay = 3'd0;
        drive_bit(1'b1, 1'b1);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Delay 7 Check", test_num);
        reset_dut();
        delay = 3'd7;




        drive_bit(1'b1, 1'b1);
        drive_bit(1'b0, 1'b1);
        drive_bit(1'b0, 1'b1);
        drive_bit(1'b0, 1'b1);
        drive_bit(1'b0, 1'b1);
        drive_bit(1'b0, 1'b1);
        drive_bit(1'b0, 1'b1);
        drive_bit(1'b0, 1'b1);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Sync Control Check", test_num);
        reset_dut();
        delay = 3'd0;

        drive_bit(1'b1, 1'b1);
        drive_bit(1'b0, 1'b0);
        drive_bit(1'b0, 1'b0);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Intermediate Delay 3 Check", test_num);
        reset_dut();
        delay = 3'd3;



        drive_bit(1'b1, 1'b1);
        drive_bit(1'b0, 1'b1);
        drive_bit(1'b1, 1'b1);
        drive_bit(1'b0, 1'b1);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mid-operation Reset Check", test_num);
        reset_dut();
        delay = 3'd0;

        drive_bit(1'b1, 1'b1);

        @(negedge clk);
        reset = 1;
        @(negedge clk);
        reset = 0;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Delay Selection Toggle Check", test_num);
        reset_dut();


        drive_bit(1'b1, 1'b1);
        drive_bit(1'b0, 1'b1);
        drive_bit(1'b1, 1'b1);

        delay = 3'd2;
        #1;
        if (out === 1'b1) begin
             delay = 3'd1;
             #1;
             #1;

             check_outputs(1'b0);
        end else begin
             #1;

             check_outputs(1'b1);
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
        testcase006();
        
        
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
        $dumpvars(0,clk, delay, in, reset, sync, out);
    end

endmodule
