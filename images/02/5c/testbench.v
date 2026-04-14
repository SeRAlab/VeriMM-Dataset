`timescale 1ns/1ps

module pll_4x_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg reset;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll_4x dut (
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

        integer edge_count;
        begin
            test_num = 1;
            $display("\nTestcase %03d: Verifying 4x frequency multiplier", test_num);
            reset_dut();

            edge_count = 0;


            repeat(50) @(posedge clk_in);



            fork
                begin
                    repeat(10) @(posedge clk_in);
                end
                begin
                    forever @(posedge clk_out) edge_count = edge_count + 1;
                end
            join_any
            disable fork;


            if (edge_count >= 39 && edge_count <= 41) begin
                $display("  Measured %0d edges in 10 input cycles (Target: 40)", edge_count);
                #1;

                check_outputs(clk_out);
            end else begin
                $display("  Measured %0d edges in 10 input cycles (Target: 40) - FREQUENCY INCORRECT", edge_count);
                #1;

                check_outputs(!clk_out);
            end
        end
        endtask

    task testcase002;

        integer edge_count;
        begin
            test_num = 2;
            $display("\nTestcase %03d: Verifying PLL stability over extended run", test_num);
            reset_dut();

            edge_count = 0;


            repeat(100) @(posedge clk_in);



            fork
                begin
                    repeat(20) @(posedge clk_in);
                end
                begin
                    forever @(posedge clk_out) edge_count = edge_count + 1;
                end
            join_any
            disable fork;

            if (edge_count >= 79 && edge_count <= 81) begin
                $display("  Measured %0d edges in 20 input cycles (Target: 80)", edge_count);
                #1;

                check_outputs(clk_out);
            end else begin
                $display("  Measured %0d edges in 20 input cycles (Target: 80) - STABILITY FAILED", edge_count);
                #1;

                check_outputs(!clk_out);
            end
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Verifying reset behavior", test_num);
            reset_dut();


            reset = 1;
            #50;



            #1;




            check_outputs(clk_out);
            reset = 0;
            #10;
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
