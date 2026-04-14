`timescale 1ns/1ps

module pll_8x_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg reset;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll_8x dut (
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
            repeat(5) @(posedge clk_in);
            #2 reset = 0;
            $display("DUT Reset complete.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checking clk_out behavior during reset", test_num);
            reset = 1;
            repeat(5) @(posedge clk_in);

            if (clk_out === 1'b0 || clk_out === 1'bz) begin
                $display("PASS: clk_out is inactive during reset.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: clk_out is toggling during reset.");
                fail_count = fail_count + 1;
            end
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying 8x frequency multiplication", test_num);
            reset_dut();


            repeat(100) @(posedge clk_in);

            edge_count = 0;


            @(posedge clk_in);


            fork
                begin
                    @(posedge clk_in);
                end
                begin
                    forever @(posedge clk_out) begin
                        edge_count = edge_count + 1;
                    end
                end
            join_any
            disable fork;


            if (edge_count == 8) begin
                $display("PASS: Detected %0d output pulses for 1 input pulse.", edge_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Detected %0d output pulses. Expected: 8", edge_count);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying output clock period stability", test_num);
            reset_dut();

            repeat(50) @(posedge clk_in);

            @(posedge clk_out);
            t1 = $realtime;
            @(posedge clk_out);
            t2 = $realtime;

            period_out = t2 - t1;

            if (period_out > 1.24 && period_out < 1.26) begin
                $display("PASS: Measured clk_out period: %0.3fns (Target: 1.25ns)", period_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Measured clk_out period: %0.3fns (Target: 1.25ns)", period_out);
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
        $dumpvars(0,clk_in, reset, clk_out);
    end

endmodule
