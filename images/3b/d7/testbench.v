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
            $display("Running testcase%03d: Reset State Verification", test_num);
            reset = 1;
            #25;


            #1;



            check_outputs(1'b0);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running testcase%03d: 8x Frequency Multiplier Check (1 Input Cycle)", test_num);
            reset_dut();
            edge_count = 0;


            @(posedge clk_in);


            fork
                begin
                    #10;
                end
                begin
                    forever @(posedge clk_out) edge_count = edge_count + 1;
                end
            join_any
            disable fork;


            if (edge_count == 8)
                test_success = clk_out;
            else
                test_success = ~clk_out;


            #1;



            check_outputs(clk_out);


            if (edge_count != 8) begin
                $display("  Frequency Error: Expected 8 edges, Got %0d", edge_count);
                pass_count = pass_count - 1;
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running testcase%03d: Long-term Stability (10 Input Cycles)", test_num);
            reset_dut();
            edge_count = 0;

            @(posedge clk_in);
            fork
                begin
                    repeat(10) @(posedge clk_in);
                end
                begin
                    forever @(posedge clk_out) edge_count = edge_count + 1;
                end
            join_any
            disable fork;

            if (edge_count == 80)
                #1;

                check_outputs(clk_out);
            else begin
                $display("  Stability Error: Expected 80 edges, Got %0d", edge_count);

                #1;


                check_outputs(!clk_out);
            end
        end
        endtask

    task testcase004;

        reg last_val;
        begin
            test_num = 4;
            $display("Running testcase%03d: Toggle Verification", test_num);
            reset_dut();
            #1.25;
            last_val = clk_out;
            #1.25;

            if (clk_out !== last_val)
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
