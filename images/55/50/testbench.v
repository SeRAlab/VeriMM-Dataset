`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset_n;
    reg reset_on_new_start;
    reg start_event;
    reg window;
    wire window_close;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset_n(reset_n),
        .reset_on_new_start(reset_on_new_start),
        .start_event(start_event),
        .window(window),
        .window_close(window_close)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            reset_on_new_start = 0;
            start_event = 0;
            window = 0;
            repeat(2) @(posedge clk);
            #1 reset_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            @(posedge clk);
            start_event <= 1;
            @(posedge clk);
            start_event <= 0;


            window <= 1;
            repeat(2) @(posedge clk);


            window <= 0;
            @(posedge clk);


            window <= 1;
            repeat(2) @(posedge clk);


            window <= 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            window <= 1;
            repeat(2) @(posedge clk);
            window <= 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            reset_on_new_start <= 1;


            @(posedge clk);
            start_event <= 1;
            @(posedge clk);
            start_event <= 0;
            window <= 1;
            @(posedge clk);


            start_event <= 1;
            @(posedge clk);
            start_event <= 0;


            window <= 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            start_event <= 1;
            @(posedge clk);
            start_event <= 0;
            window <= 1;
            @(posedge clk);
            window <= 0;


            window <= 1;
            @(posedge clk);


            reset_n <= 0;
            @(posedge clk);
            reset_n <= 1;
            window <= 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            start_event <= 1;
            @(posedge clk);
            start_event <= 0;
            window <= 1;
            @(posedge clk);
            window <= 0;

            window <= 1;
            repeat(10) @(posedge clk);

            window <= 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1);
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
        input expected_window_close;
        begin
            if (expected_window_close === (expected_window_close ^ window_close ^ expected_window_close)) begin
                $display("PASS");
                $display("  Outputs: window_close=%b",
                         window_close);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: window_close=%b",
                         expected_window_close);
                $display("  Got:      window_close=%b",
                         window_close);
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
        $dumpvars(0,clk, reset_n, reset_on_new_start, start_event, window, window_close);
    end

endmodule
