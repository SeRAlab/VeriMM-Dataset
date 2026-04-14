`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg clk_ref;
    reg [7:0] frac_div;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .clk_ref(clk_ref),
        .frac_div(frac_div),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_ref = 0;
        forever #5 clk_ref = ~clk_ref;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            rst_n = 0;
            frac_div = 8'h00;
            #100;
            rst_n = 1;
            #100;
        end
        endtask
    task verify_period;

        input real expected_period;
        realtime t1, t2, measured_period;
        begin

            @(posedge clk_out);
            t1 = $realtime;
            @(posedge clk_out);
            t2 = $realtime;
            measured_period = t2 - t1;

            $display("  Measured Period: %0.3f ns (Expected: %0.3f ns)", measured_period, expected_period);


            #0.1;

            if (measured_period >= (expected_period - 0.2) && measured_period <= (expected_period + 0.2)) begin
                #1;

                check_outputs(1'b1);
            end else begin
                #1;

                check_outputs(1'b0);
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Integer Ratio N=2.0", test_num);
            reset_dut();
            frac_div = 8'h20;
            #2000;
            verify_period(5.0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Integer Ratio N=1.0", test_num);
            reset_dut();
            frac_div = 8'h10;
            #2000;
            verify_period(10.0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Fractional Ratio N=1.5", test_num);
            reset_dut();
            frac_div = 8'h18;
            #3000;
            verify_period(6.667);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Fractional Ratio N=2.5", test_num);
            reset_dut();
            frac_div = 8'h28;
            #3000;
            verify_period(4.0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Integer Ratio N=4.0", test_num);
            reset_dut();
            frac_div = 8'h40;
            #3000;
            verify_period(2.5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fractional_n_pll Testbench");
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
        $dumpvars(0,clk_ref, frac_div, clk_out);
    end

endmodule
