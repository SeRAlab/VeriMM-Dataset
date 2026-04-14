`timescale 1ns/1ps

module pll_tb;

    // Testbench signals (sequential circuit)
    reg clk_ref;
    reg reset;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll dut (
        .clk_ref(clk_ref),
        .reset(reset),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_ref = 0;
        forever #5 clk_ref = ~clk_ref;
    end

        task reset_dut;

        begin
            reset = 1;
            #100;
            reset = 0;
            #50;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checking reset state...", test_num);
            reset = 1;
            #100;

            #1;


            check_outputs(1'b0);
            reset = 0;
        end
        endtask

    task testcase002;

        reg osc_detected;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checking for clock oscillation (Locking)...", test_num);
            reset_dut();
            osc_detected = 0;


            #2000;


            fork
                begin
                    @(posedge clk_out);
                    osc_detected = 1;
                end
                begin
                    #100;
                end
            join_any


            if (osc_detected)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(~clk_out);
        end
        endtask

    task testcase003;

        realtime t1, t2, measured_period;
        realtime expected_period;
        begin
            test_num = test_num + 1;
            expected_period = 5.0;
            $display("Testcase %03d: Checking frequency multiplier (Expected %0.1fns)...", test_num, expected_period);
            reset_dut();

            #5000;

            @(posedge clk_out);
            t1 = $realtime;
            @(posedge clk_out);
            t2 = $realtime;
            measured_period = t2 - t1;

            $display("  Measured clk_out period: %0.3f ns", measured_period);


            if (measured_period >= (expected_period * 0.95) && measured_period <= (expected_period * 1.05))
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
        $display("pll Testbench");
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
        $dumpvars(0,clk_ref, reset, clk_out);
    end

endmodule
