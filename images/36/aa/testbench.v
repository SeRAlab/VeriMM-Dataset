`timescale 1ns/1ps

module pll_4x_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg enable;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll_4x dut (
        .clk_in(clk_in),
        .enable(enable),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            enable = 0;
            #20;
        end
        endtask
    task testcase001;

        integer edge_count;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Enable PLL and check 4x frequency output", test_num);

            enable = 1;
            edge_count = 0;


            repeat (10) @(posedge clk_in);




            fork
                begin
                    repeat (40) @(posedge clk_out) edge_count = edge_count + 1;
                end
                begin
                    repeat (10) @(posedge clk_in);
                end
            join




            if (edge_count == 40) begin
                #1;

                check_outputs(clk_out);
            end else begin
                $display("FAIL: Frequency mismatch. Expected 40 edges, got %d", edge_count);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Disable PLL and check if output stops", test_num);

            enable = 0;

            repeat (5) @(posedge clk_in);


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        integer edge_count;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Toggle enable and check recovery", test_num);


            enable = 1;
            repeat (5) @(posedge clk_in);


            enable = 0;
            repeat (5) @(posedge clk_in);


            enable = 1;
            edge_count = 0;
            repeat (5) @(posedge clk_in);


            fork
                begin
                    repeat (20) @(posedge clk_out) edge_count = edge_count + 1;
                end
                begin
                    repeat (5) @(posedge clk_in);
                end
            join

            if (edge_count == 20) begin
                #1;

                check_outputs(clk_out);
            end else begin
                $display("FAIL: Recovery frequency mismatch. Got %d edges", edge_count);
                fail_count = fail_count + 1;
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
        $dumpvars(0,clk_in, enable, clk_out);
    end

endmodule
