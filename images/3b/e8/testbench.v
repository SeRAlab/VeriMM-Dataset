`timescale 1ns/1ps

module pll_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg rst_n;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll dut (
        .clk_in(clk_in),
        .rst_n(rst_n),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            $display("  Resetting circuit...");
            rst_n = 1'b0;
            #100;
            rst_n = 1'b1;
            #50;
        end
        endtask
    task testcase001;

        realtime t1, t2;
        realtime period;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial Lock Frequency Check", test_num);
            reset_dut();


            repeat(100) @(posedge clk_in);


            @(posedge clk_out);
            t1 = $realtime;
            @(posedge clk_out);
            t2 = $realtime;
            period = t2 - t1;

            $display("  Measured clk_out period: %0t ns (Target: 5ns)", period);


            @(posedge clk_out);
            #1;
            if (period >= 4.9 && period <= 5.1) begin
                #1;

                check_outputs(1'b1);
            end else begin
                #1;

                check_outputs(~clk_out);
            end
        end
        endtask

    task testcase002;

        realtime t1, t2;
        realtime period;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Stability Check", test_num);
            reset_dut();


            repeat(500) @(posedge clk_in);


            @(posedge clk_out);
            t1 = $realtime;
            @(posedge clk_out);
            t2 = $realtime;
            period = t2 - t1;

            $display("  Measured clk_out period after 500 cycles: %0t ns", period);

            @(posedge clk_out);
            #1;
            if (period >= 4.95 && period <= 5.05) begin
                #1;

                check_outputs(1'b1);
            end else begin
                #1;

                check_outputs(~clk_out);
            end
        end
        endtask

    task testcase003;

        realtime t1, t2;
        realtime period;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Re-lock after reset disturbance", test_num);


            reset_dut();
            repeat(50) @(posedge clk_in);


            $display("  Applying secondary reset...");
            rst_n = 1'b0;
            #200;
            rst_n = 1'b1;


            repeat(200) @(posedge clk_in);

            @(posedge clk_out);
            t1 = $realtime;
            @(posedge clk_out);
            t2 = $realtime;
            period = t2 - t1;

            $display("  Measured clk_out period after re-lock: %0t ns", period);

            @(posedge clk_out);
            #1;
            if (period >= 4.9 && period <= 5.1) begin
                #1;

                check_outputs(1'b1);
            end else begin
                #1;

                check_outputs(~clk_out);
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
        $display("pll Testbench");
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
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
        $dumpvars(0,clk_in, rst_n, clk_out);
    end

endmodule
