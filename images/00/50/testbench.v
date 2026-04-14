`timescale 1ns/1ps

module pll_4x_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg reset;
    wire clk_out;
    wire locked;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll_4x dut (
        .clk_in(clk_in),
        .reset(reset),
        .clk_out(clk_out),
        .locked(locked)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            reset = 1;
            #40;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying reset state", test_num);
            reset = 1;
            #100;


            #1;



            check_outputs(clk_out, 0);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying lock acquisition", test_num);
            reset_dut();


            fork : wait_for_lock
                begin
                    wait(locked == 1);
                end
                begin
                    #2000;
                end
            join_any
            disable wait_for_lock;


            #1;



            check_outputs(clk_out, 1);
        end
        endtask

    task testcase003;

        integer i;
        time start_time;
        time end_time;
        real period_in;
        real period_out;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying 4x frequency multiplication", test_num);
            reset_dut();


            wait(locked == 1);
            repeat(10) @(posedge clk_in);


            @(posedge clk_in);
            start_time = $time;
            @(posedge clk_in);
            end_time = $time;
            period_in = end_time - start_time;


            @(posedge clk_out);
            start_time = $time;
            @(posedge clk_out);
            end_time = $time;
            period_out = end_time - start_time;

            $display("  Measured clk_in period: %0fnns", period_in);
            $display("  Measured clk_out period: %0fnns", period_out);


            if (period_out > 0 && (period_in / period_out) > 3.9 && (period_in / period_out) < 4.1) begin
                $display("  Frequency ratio 4x confirmed.");
                #1;

                check_outputs(clk_out, 1);
            end else begin
                $display("  Frequency ratio mismatch! Ratio: %0f", period_in / period_out);

                #1;


                check_outputs(clk_out, 0);
            end
        end
        endtask

    task testcase004;

        integer edge_count;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying output stability (pulse counting)", test_num);
            reset_dut();

            wait(locked == 1);
            edge_count = 0;


            @(posedge clk_in);
            fork
                begin
                    repeat(10) @(posedge clk_in);
                end
                begin
                    forever begin
                        @(posedge clk_out);
                        edge_count = edge_count + 1;
                    end
                end
            join_any
            disable fork;

            $display("  Edges counted: %0d (Expected 40)", edge_count);

            if (edge_count == 40)
                #1;

                check_outputs(clk_out, 1);
            else
                #1;

                check_outputs(clk_out, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pll_4x Testbench");
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
        input expected_clk_out;
        input expected_locked;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out) &&
                expected_locked === (expected_locked ^ locked ^ expected_locked)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b, locked=%b",
                         clk_out, locked);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b, locked=%b",
                         expected_clk_out, expected_locked);
                $display("  Got:      clk_out=%b, locked=%b",
                         clk_out, locked);
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
        $dumpvars(0,clk_in, reset, clk_out, locked);
    end

endmodule
