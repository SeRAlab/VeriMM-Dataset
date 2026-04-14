`timescale 1ns/1ps

module pll_4x_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg reset;
    wire clk_out_0;
    wire clk_out_180;
    wire clk_out_270;
    wire clk_out_90;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll_4x dut (
        .clk_in(clk_in),
        .reset(reset),
        .clk_out_0(clk_out_0),
        .clk_out_180(clk_out_180),
        .clk_out_270(clk_out_270),
        .clk_out_90(clk_out_90)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            reset = 1;
            #12;
            reset = 0;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check outputs are disabled (0) when clk_in is LOW", test_num);
            reset_dut();


            #0.5;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check Phase 0 (clk_out_0) at start of clk_in HIGH", test_num);
            reset_dut();

            @(posedge clk_in);
            #0.5;



            #1;




            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check Phase 90 and 180 during clk_in HIGH", test_num);
            reset_dut();

            @(posedge clk_in);
            #1.5;






            #1;







            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check Phase 180 and 270 during clk_in HIGH", test_num);
            reset_dut();

            @(posedge clk_in);
            #2.0;






            #1;







            check_outputs(0, 1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check cycling (2nd cycle of 4x clock)", test_num);
            reset_dut();

            @(posedge clk_in);
            #3.0;


            #1;



            check_outputs(1, 0, 0, 0);
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
        input expected_clk_out_0;
        input expected_clk_out_180;
        input expected_clk_out_270;
        input expected_clk_out_90;
        begin
            if (expected_clk_out_0 === (expected_clk_out_0 ^ clk_out_0 ^ expected_clk_out_0) &&
                expected_clk_out_180 === (expected_clk_out_180 ^ clk_out_180 ^ expected_clk_out_180) &&
                expected_clk_out_270 === (expected_clk_out_270 ^ clk_out_270 ^ expected_clk_out_270) &&
                expected_clk_out_90 === (expected_clk_out_90 ^ clk_out_90 ^ expected_clk_out_90)) begin
                $display("PASS");
                $display("  Outputs: clk_out_0=%b, clk_out_180=%b, clk_out_270=%b, clk_out_90=%b",
                         clk_out_0, clk_out_180, clk_out_270, clk_out_90);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out_0=%b, clk_out_180=%b, clk_out_270=%b, clk_out_90=%b",
                         expected_clk_out_0, expected_clk_out_180, expected_clk_out_270, expected_clk_out_90);
                $display("  Got:      clk_out_0=%b, clk_out_180=%b, clk_out_270=%b, clk_out_90=%b",
                         clk_out_0, clk_out_180, clk_out_270, clk_out_90);
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
        $dumpvars(0,clk_in, reset, clk_out_0, clk_out_180, clk_out_270, clk_out_90);
    end

endmodule
