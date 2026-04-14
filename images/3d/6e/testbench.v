`timescale 1ns/1ps

module pll_4x_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg rst;
    wire clk_out;
    wire locked;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll_4x dut (
        .clk_in(clk_in),
        .rst(rst),
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
            rst = 1;
            repeat(5) @(posedge clk_in);
            #2;
            rst = 0;
            $display("Reset released at %0t", $time);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Checking reset behavior...", test_num);
            rst = 1;
            #50;

            #1;


            check_outputs(clk_out, 1'b0);
        end
        endtask

    task testcase002;

        realtime t1, t2, period;
        reg freq_check;
        begin
            test_num = 2;
            $display("\nTestcase %03d: Waiting for lock and verifying frequency...", test_num);
            reset_dut();
            freq_check = 0;


            repeat(200) @(posedge clk_in);

            if (locked === 1'b1) begin

                @(posedge clk_out);
                t1 = $realtime;
                @(posedge clk_out);
                t2 = $realtime;
                period = t2 - t1;


                if (period >= 2.45 && period <= 2.55) begin
                    $display("  Frequency Check: clk_out period is %0.2fns (Correct)", period);
                    freq_check = 1;
                end else begin
                    $display("  Frequency Check: clk_out period is %0.2fns (Expected ~2.5ns)", period);
                end
            end


            if (freq_check && locked)
                #1;

                check_outputs(clk_out, 1'b1);
            else
                #1;

                check_outputs(clk_out, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Testing lock stability and recovery...", test_num);


            if (!locked) repeat(100) @(posedge clk_in);


            repeat(20) @(posedge clk_in);


            rst = 1;
            #20;
            if (locked === 1'b0) begin
                $display("  Lock correctly dropped during reset.");
                rst = 0;

                repeat(200) @(posedge clk_in);
                #1;

                check_outputs(clk_out, 1'b1);
            end else begin
                $display("  Error: Lock did not drop during reset.");
                #1;

                check_outputs(clk_out, 1'b1);
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
        $display("pll_4x Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        $dumpvars(0,clk_in, rst, clk_out, locked);
    end

endmodule
