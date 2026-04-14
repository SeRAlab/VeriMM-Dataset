`timescale 1ns/1ps

module pll_4x_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg reset;
    wire clk_out;
    wire lock;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll_4x dut (
        .clk_in(clk_in),
        .reset(reset),
        .clk_out(clk_out),
        .lock(lock)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            $display("Resetting PLL...");
            reset = 1;
            #100;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Post-reset lock status", test_num);
            reset_dut();

            #1;


            check_outputs(clk_out, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Lock acquisition check", test_num);
            reset_dut();


            #500;


            #1;



            check_outputs(clk_out, 1'b1);
        end
        endtask

    task testcase003;

        integer rising_edges;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 4x Frequency Verification", test_num);
            reset_dut();


            #1000;

            rising_edges = 0;

            @(posedge clk_in);



            fork : count_block
                begin
                    repeat (16) @(posedge clk_out) rising_edges = rising_edges + 1;
                end
                #40.5;
            join_any
            disable count_block;


            if (rising_edges == 16 && lock == 1'b1) begin
                #1;

                check_outputs(clk_out, 1'b1);
            end else begin
                $display("  Frequency Error: Detected %0d output edges in 4 input cycles.", rising_edges);
                #1;

                check_outputs(!clk_out, 1'b1);
            end
        end
        endtask

    task testcase004;

        reg lock_stable;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Lock stability over long duration", test_num);
            reset_dut();

            #500;
            lock_stable = 1'b1;


            for (i = 0; i < 100; i = i + 1) begin
                #10;
                if (lock !== 1'b1) lock_stable = 1'b0;
            end

            if (lock_stable)
                #1;

                check_outputs(clk_out, 1'b1);
            else
                #1;

                check_outputs(clk_out, 1'b0);
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
        input expected_lock;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out) &&
                expected_lock === (expected_lock ^ lock ^ expected_lock)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b, lock=%b",
                         clk_out, lock);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b, lock=%b",
                         expected_clk_out, expected_lock);
                $display("  Got:      clk_out=%b, lock=%b",
                         clk_out, lock);
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
        $dumpvars(0,clk_in, reset, clk_out, lock);
    end

endmodule
