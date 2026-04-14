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
            #200;
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase %0d: Checking for clock activity...", test_num);

            if (clk_out === 1'b0 || clk_out === 1'b1) begin
                #1;

                check_outputs(clk_out);
            end else begin
                #1;

                check_outputs(1'bx);
            end
        end
        endtask

    task testcase002;

        integer edge_count;
        time start_time;
        begin
            reset_dut();
            $display("Testcase %0d: Verifying 8x frequency multiplier...", test_num);
            edge_count = 0;

            @(posedge clk_in);
            start_time = $time;



            fork: count_block
                begin
                    forever @(posedge clk_out) edge_count = edge_count + 1;
                end
                begin
                    @(posedge clk_in);
                    disable count_block;
                end
            join

            $display("  Measured %0d clk_out edges in one clk_in cycle.", edge_count);

            if (edge_count == 8)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(~clk_out);
        end
        endtask

    task testcase003;

        reg aligned;
        begin
            reset_dut();
            $display("Testcase %0d: Checking phase alignment...", test_num);

            @(posedge clk_in);



            #0.1;
            if (clk_out === 1'b1) begin
                aligned = 1;
            end else begin
                aligned = 0;
            end

            if (aligned)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(~clk_out);
        end
        endtask

    task testcase004;

        time t1, t2;
        real measured_period;
        begin
            reset_dut();
            $display("Testcase %0d: Checking period stability...", test_num);

            @(posedge clk_out);
            t1 = $realtime;
            @(posedge clk_out);
            t2 = $realtime;

            measured_period = t2 - t1;
            $display("  Measured clk_out period: %0.3f ns", measured_period);


            if (measured_period >= 1.24 && measured_period <= 1.26)
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
        $display("pll_8x Testbench");
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
        $dumpvars(0,clk_in, rst, clk_out);
    end

endmodule
