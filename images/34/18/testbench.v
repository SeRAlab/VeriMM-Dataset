`timescale 1ns/1ps

module pll_4x_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ref_freq;
    reg reset;
    wire vco_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll_4x dut (
        .clk(clk),
        .ref_freq(ref_freq),
        .reset(reset),
        .vco_out(vco_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ref_freq = 0;
            #100;
            reset = 0;
            #100;
        end
        endtask
    task drive_ref;

        input integer half_period_ns;
        input integer num_cycles;
        integer i;
        begin
            for (i = 0; i < num_cycles; i = i + 1) begin
                #half_period_ns ref_freq = 1;
                #half_period_ns ref_freq = 0;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input Freq = 1.25MHz (Period 800ns)", test_num);
            reset_dut();


            fork
                drive_ref(400, 100);
                begin
                    #60000;
                    @(posedge vco_out);
                    t1 = $realtime;
                    @(posedge vco_out);
                    t2 = $realtime;
                    measured_period = t2 - t1;


                    if (measured_period >= 195 && measured_period <= 205)
                        test_success = 1;
                    else
                        test_success = 0;
                end
            join


            #1;



            check_outputs(test_success ? vco_out : !vco_out);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input Freq = 2.5MHz (Period 400ns)", test_num);
            reset_dut();

            fork
                drive_ref(200, 200);
                begin
                    #40000;
                    @(posedge vco_out);
                    t1 = $realtime;
                    @(posedge vco_out);
                    t2 = $realtime;
                    measured_period = t2 - t1;


                    if (measured_period >= 95 && measured_period <= 105)
                        test_success = 1;
                    else
                        test_success = 0;
                end
            join

            #1;


            check_outputs(test_success ? vco_out : !vco_out);
        end
        endtask

    task testcase003;

        integer vco_edges;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Ratio verification (4:1 edge count)", test_num);
            reset_dut();
            vco_edges = 0;

            fork
                drive_ref(500, 50);
                begin
                    #40000;

                    @(posedge ref_freq);
                    @(posedge ref_freq);
                    fork
                        @(posedge ref_freq);
                        forever @(posedge vco_out) vco_edges = vco_edges + 1;
                    join_any

                    if (vco_edges == 4)
                        test_success = 1;
                    else begin
                        $display("  Error: Counted %0d VCO edges per Ref cycle", vco_edges);
                        test_success = 0;
                    end
                end
            join

            #1;


            check_outputs(test_success ? vco_out : !vco_out);
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
        input expected_vco_out;
        begin
            if (expected_vco_out === (expected_vco_out ^ vco_out ^ expected_vco_out)) begin
                $display("PASS");
                $display("  Outputs: vco_out=%b",
                         vco_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vco_out=%b",
                         expected_vco_out);
                $display("  Got:      vco_out=%b",
                         vco_out);
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
        $dumpvars(0,clk, ref_freq, reset, vco_out);
    end

endmodule
