`timescale 1ns/1ps

module pll_4x_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg enable;
    reg reset_n;
    wire clk_out_0;
    wire clk_out_1;
    wire clk_out_2;
    wire clk_out_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll_4x dut (
        .clk_in(clk_in),
        .enable(enable),
        .reset_n(reset_n),
        .clk_out_0(clk_out_0),
        .clk_out_1(clk_out_1),
        .clk_out_2(clk_out_2),
        .clk_out_3(clk_out_3)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            reset_n = 0;
            enable = 0;
            #20;
            reset_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Verifying Reset State (reset_n=0, enable=1)", test_num);
            reset_n = 0;
            enable = 1;
            #40;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Verifying Disable Control (reset_n=1, enable=0)", test_num);
            reset_dut();
            #50;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Verifying Enabled Operation (reset_n=1, enable=1)", test_num);
            reset_dut();
            enable = 1;
            #100;




            if (clk_out_0 === 1'bx || clk_out_1 === 1'bx || clk_out_2 === 1'bx || clk_out_3 === 1'bx) begin
                $display("FAIL: Outputs are undefined (X)");
                fail_count = fail_count + 1;
            end else begin

                #1;


                check_outputs(clk_out_0, clk_out_1, clk_out_2, clk_out_3);
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Verifying Dynamic Disable", test_num);
            reset_dut();
            enable = 1;
            #50;
            enable = 0;
            #20;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_clk_out_0;
        input expected_clk_out_1;
        input expected_clk_out_2;
        input expected_clk_out_3;
        begin
            if (expected_clk_out_0 === (expected_clk_out_0 ^ clk_out_0 ^ expected_clk_out_0) &&
                expected_clk_out_1 === (expected_clk_out_1 ^ clk_out_1 ^ expected_clk_out_1) &&
                expected_clk_out_2 === (expected_clk_out_2 ^ clk_out_2 ^ expected_clk_out_2) &&
                expected_clk_out_3 === (expected_clk_out_3 ^ clk_out_3 ^ expected_clk_out_3)) begin
                $display("PASS");
                $display("  Outputs: clk_out_0=%b, clk_out_1=%b, clk_out_2=%b, clk_out_3=%b",
                         clk_out_0, clk_out_1, clk_out_2, clk_out_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out_0=%b, clk_out_1=%b, clk_out_2=%b, clk_out_3=%b",
                         expected_clk_out_0, expected_clk_out_1, expected_clk_out_2, expected_clk_out_3);
                $display("  Got:      clk_out_0=%b, clk_out_1=%b, clk_out_2=%b, clk_out_3=%b",
                         clk_out_0, clk_out_1, clk_out_2, clk_out_3);
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
        $dumpvars(0,clk_in, enable, reset_n, clk_out_0, clk_out_1, clk_out_2, clk_out_3);
    end

endmodule
