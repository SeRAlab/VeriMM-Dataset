`timescale 1ns/1ps

module PLL_8x_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg reset;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PLL_8x dut (
        .clk_in(clk_in),
        .reset(reset),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            $display("Applying Reset...");
            reset = 1;
            #25;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        integer edge_count;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic 8x Frequency Verification", test_num);
            reset_dut();

            edge_count = 0;


            repeat(20) @(posedge clk_in);



            fork : measure_freq
                forever @(clk_out) edge_count = edge_count + 1;
                repeat(10) @(posedge clk_in);
            join_any
            disable measure_freq;

            $display("  Edges counted in 10 clk_in cycles: %0d (Expected: 160)", edge_count);


            if (edge_count >= 158 && edge_count <= 162)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(!clk_out);
        end
        endtask

    task testcase002;

        integer edge_count;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Long-term Stability Check", test_num);
            reset_dut();

            edge_count = 0;


            repeat(30) @(posedge clk_in);



            fork : measure_stability
                forever @(clk_out) edge_count = edge_count + 1;
                repeat(50) @(posedge clk_in);
            join_any
            disable measure_stability;

            $display("  Edges counted in 50 clk_in cycles: %0d (Expected: 800)", edge_count);

            if (edge_count >= 795 && edge_count <= 805)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(!clk_out);
        end
        endtask

    task testcase003;

        integer edge_count;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Lock after Re-Reset Check", test_num);


            reset_dut();
            repeat(10) @(posedge clk_in);


            reset_dut();
            edge_count = 0;


            repeat(20) @(posedge clk_in);



            fork : measure_re_reset
                forever @(clk_out) edge_count = edge_count + 1;
                repeat(5) @(posedge clk_in);
            join_any
            disable measure_re_reset;

            $display("  Edges counted in 5 clk_in cycles: %0d (Expected: 80)", edge_count);

            if (edge_count >= 79 && edge_count <= 81)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(!clk_out);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PLL_8x Testbench");
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
        $dumpvars(0,clk_in, reset, clk_out);
    end

endmodule
