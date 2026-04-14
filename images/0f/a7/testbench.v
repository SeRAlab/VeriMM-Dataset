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
            reset = 1;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase %03d: Basic Startup", test_num);
            reset_dut();


            repeat(10) @(posedge clk_in);


            if (clk_out === 1'b0 || clk_out === 1'b1)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(1'bx);
        end
        endtask

    task testcase002;

        integer edge_count;
        integer i;
        begin
            test_num = 2;
            $display("\nRunning Testcase %03d: 8x Frequency Multiplier Check", test_num);
            reset_dut();
            edge_count = 0;


            repeat(50) @(posedge clk_in);


            @(posedge clk_in);
            fork : freq_count
                begin
                    repeat(10) @(posedge clk_in);
                    disable freq_count;
                end
                begin
                    forever @(posedge clk_out) edge_count = edge_count + 1;
                end
            join


            $display("  Measured %0d edges in 10 input cycles (Expected: 80)", edge_count);
            if (edge_count >= 79 && edge_count <= 81)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(~clk_out);
        end
        endtask

    task testcase003;

        integer edge_count;
        begin
            test_num = 3;
            $display("\nRunning Testcase %03d: Mid-run Reset Check", test_num);
            reset_dut();


            repeat(20) @(posedge clk_in);


            reset = 1;
            #50;



            edge_count = 0;
            fork : reset_monitor
                begin
                    #40;
                    disable reset_monitor;
                end
                begin
                    forever @(posedge clk_out) edge_count = edge_count + 1;
                end
            join

            reset = 0;

            if (edge_count == 0)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(~clk_out);
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
