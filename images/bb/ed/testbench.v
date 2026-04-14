`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cnt_done;
    reg lsb;
    reg start;
    wire add;
    wire count_up;
    wire done;
    wire shift;
    wire start_process;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cnt_done(cnt_done),
        .lsb(lsb),
        .start(start),
        .add(add),
        .count_up(count_up),
        .done(done),
        .shift(shift),
        .start_process(start_process)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            cnt_done = 0;
            lsb = 0;
            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Full cycle to finish state", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);
            #1 start = 0;


            lsb = 1;
            @(posedge clk);
            #1;


            cnt_done = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(0, 0, 1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Idle state check", test_num);
            reset_dut();

            repeat (5) @(posedge clk);
            #1;


            #1;



            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Wait in 'on' state for LSB", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);
            #1 start = 0;
            lsb = 0;

            repeat (2) @(posedge clk);
            #1;



            if (done === 0) begin
                $display("PASS: Still waiting for LSB");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Prematurely finished");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Process state control signals", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0; lsb = 1;
            @(posedge clk);
            #1;


            if (shift === 1 && count_up === 1) begin
                $display("PASS: Shift and count_up active in process");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Process signals not active. Shift=%b, count_up=%b", shift, count_up);
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
        input expected_add;
        input expected_count_up;
        input expected_done;
        input expected_shift;
        input expected_start_process;
        begin
            if (expected_add === (expected_add ^ add ^ expected_add) &&
                expected_count_up === (expected_count_up ^ count_up ^ expected_count_up) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_shift === (expected_shift ^ shift ^ expected_shift) &&
                expected_start_process === (expected_start_process ^ start_process ^ expected_start_process)) begin
                $display("PASS");
                $display("  Outputs: add=%b, count_up=%b, done=%b, shift=%b, start_process=%b",
                         add, count_up, done, shift, start_process);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add=%b, count_up=%b, done=%b, shift=%b, start_process=%b",
                         expected_add, expected_count_up, expected_done, expected_shift, expected_start_process);
                $display("  Got:      add=%b, count_up=%b, done=%b, shift=%b, start_process=%b",
                         add, count_up, done, shift, start_process);
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
        $dumpvars(0,clk, cnt_done, lsb, start, add, count_up, done, shift, start_process);
    end

endmodule
