`timescale 1ns/1ps

module pll_8x_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg rst;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll_8x dut (
        .clk_in(clk_in),
        .rst(rst),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            rst = 1;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Verifying reset state initialization", test_num);
            rst = 1;
            #15;
            #1;

            check_outputs(1'b0);
            rst = 0;
            #5;
        end
        endtask

    task testcase002;

        integer edge_count;
        begin
            test_num = 2;
            $display("Testcase %03d: Verifying 8x frequency (counting edges in 10ns)", test_num);
            reset_dut();
            edge_count = 0;

            @(posedge clk_in);
            fork : count_block_1
                begin

                    forever @(posedge clk_out) edge_count = edge_count + 1;
                end
                begin
                    #10.1;
                    disable count_block_1;
                end
            join


            if (edge_count == 8)
                #1;

                check_outputs(clk_out);
            else begin
                $display("  Frequency Error: Detected %0d edges, expected 8.", edge_count);
                #1;

                check_outputs(~clk_out);
            end
        end
        endtask

    task testcase003;

        integer edge_count;
        begin
            test_num = 3;
            $display("Testcase %03d: Verifying long-term stability (80 edges in 100ns)", test_num);
            reset_dut();
            edge_count = 0;

            @(posedge clk_in);
            fork : count_block_10
                begin
                    forever @(posedge clk_out) edge_count = edge_count + 1;
                end
                begin
                    #100.1;
                    disable count_block_10;
                end
            join

            if (edge_count == 80)
                #1;

                check_outputs(clk_out);
            else begin
                $display("  Stability Error: Detected %0d edges, expected 80.", edge_count);
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
        $display("pll_8x Testbench");
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
        $dumpvars(0,clk_in, rst, clk_out);
    end

endmodule
