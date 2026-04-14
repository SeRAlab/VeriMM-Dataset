`timescale 1ns/1ps

module PLL_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ref_signal;
    reg reset;
    wire vco_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PLL dut (
        .clk(clk),
        .ref_signal(ref_signal),
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
            ref_signal = 0;
            #(50);
            reset = 0;
            #(50);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Frequency Lock (100kHz)", test_num);
            reset_dut();


            drive_ref(10000, 200000);



            #1;




            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset = 1;
            ref_signal = 1;
            #200;

            #1;


            check_outputs(1'b0);
            reset = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Frequency Tracking (200kHz)", test_num);
            reset_dut();


            drive_ref(5000, 200000);



            ref_signal = 1;
            #(2500);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Long-term Stability", test_num);
            reset_dut();


            drive_ref(20000, 500000);


            ref_signal = 0;
            #10000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Low Frequency Tracking (25kHz)", test_num);
            reset_dut();


            drive_ref(40000, 240000);


            ref_signal = 1;
            #(20000);
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PLL Testbench");
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
        $dumpvars(0,clk, ref_signal, reset, vco_out);
    end

endmodule
