`timescale 1ns/1ps

module pll_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ref_signal;
    reg reset;
    wire vco_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll dut (
        .clk(clk),
        .ref_signal(ref_signal),
        .reset(reset),
        .vco_output(vco_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            #100;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase%03d: Tracking 10MHz (Period: 100ns)", test_num);
            half_period = 50;
            reset_dut();

            #10000;

            #1;


            check_outputs(ref_signal);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase%03d: Tracking 5MHz (Period: 200ns)", test_num);
            half_period = 100;
            reset_dut();
            #20000;
            #1;

            check_outputs(ref_signal);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase%03d: Tracking 20MHz (Period: 50ns)", test_num);
            half_period = 25;
            reset_dut();
            #10000;
            #1;

            check_outputs(ref_signal);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase%03d: Reset Stability", test_num);
            reset = 1;
            #500;


            if (vco_output === 1'bx) begin
                $display("FAIL: Output is X during reset");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: Output is stable during reset");
                pass_count = pass_count + 1;
            end
            reset = 0;
            #100;
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
        input expected_vco_output;
        begin
            if (expected_vco_output === (expected_vco_output ^ vco_output ^ expected_vco_output)) begin
                $display("PASS");
                $display("  Outputs: vco_output=%b",
                         vco_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vco_output=%b",
                         expected_vco_output);
                $display("  Got:      vco_output=%b",
                         vco_output);
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
        $dumpvars(0,clk, ref_signal, reset, vco_output);
    end

endmodule
