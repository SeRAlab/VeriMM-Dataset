`timescale 1ns/1ps

module pll_2x_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg reset;
    wire clk_out1;
    wire clk_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll_2x dut (
        .clk_in(clk_in),
        .reset(reset),
        .clk_out1(clk_out1),
        .clk_out2(clk_out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            reset = 1;
            #20;
            reset = 0;


            repeat(100) @(posedge clk_in);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Phase 1 High Check", test_num);
            reset_dut();
            @(posedge clk_in);
            #1.25;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Phase 1 Low Check", test_num);
            reset_dut();
            @(posedge clk_in);
            #3.75;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Phase 2 High Check", test_num);
            reset_dut();
            @(posedge clk_in);
            #6.25;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Phase 2 Low Check", test_num);
            reset_dut();
            @(posedge clk_in);
            #8.75;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Long-term Stability Check", test_num);
            reset_dut();
            repeat(50) @(posedge clk_in);
            #1.25;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pll_2x Testbench");
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
        input expected_clk_out1;
        input expected_clk_out2;
        begin
            if (expected_clk_out1 === (expected_clk_out1 ^ clk_out1 ^ expected_clk_out1) &&
                expected_clk_out2 === (expected_clk_out2 ^ clk_out2 ^ expected_clk_out2)) begin
                $display("PASS");
                $display("  Outputs: clk_out1=%b, clk_out2=%b",
                         clk_out1, clk_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out1=%b, clk_out2=%b",
                         expected_clk_out1, expected_clk_out2);
                $display("  Got:      clk_out1=%b, clk_out2=%b",
                         clk_out1, clk_out2);
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
        $dumpvars(0,clk_in, reset, clk_out1, clk_out2);
    end

endmodule
