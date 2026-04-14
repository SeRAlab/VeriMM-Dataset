`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg clk_ref;
    reg [15:0] desired_freq;
    reg [15:0] fractional_div;
    reg [15:0] ref_freq;
    reg reset;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .clk_ref(clk_ref),
        .desired_freq(desired_freq),
        .fractional_div(fractional_div),
        .ref_freq(ref_freq),
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
        #200;
    end
        endtask
    task verify_freq;

        input real expected_period_ns;
        real t1, t2, measured_period;
        integer i;
        begin

            repeat(10) @(posedge clk_out);


            t1 = $realtime;
            repeat(20) @(posedge clk_out);
            t2 = $realtime;
            measured_period = (t2 - t1) / 20.0;


            if (measured_period >= expected_period_ns * 0.95 &&
                measured_period <= expected_period_ns * 1.05) begin

                @(posedge clk_out);
                #1;
                #1;

                check_outputs(1'b1);
            end else begin
                $display("  [Error] Measured Period: %0.3fns, Expected: %0.3fns",
                         measured_period, expected_period_ns);

                #1;


                check_outputs(~clk_out);
            end
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Integer Multiplier N=2", test_num);
        reset_dut();
        ref_freq = 16'd100;
        desired_freq = 16'd2;
        fractional_div = 16'd0;
        #10000;
        verify_freq(5.0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Integer Multiplier N=4", test_num);
        reset_dut();
        ref_freq = 16'd100;
        desired_freq = 16'd4;
        fractional_div = 16'd0;
        #10000;
        verify_freq(2.5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Fractional Multiplier N=1.5", test_num);
        reset_dut();
        ref_freq = 16'd100;
        desired_freq = 16'd1;
        fractional_div = 16'd32768;
        #10000;
        verify_freq(6.667);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Fractional Multiplier N=2.25", test_num);
        reset_dut();
        ref_freq = 16'd100;
        desired_freq = 16'd2;
        fractional_div = 16'd16384;
        #10000;
        verify_freq(4.444);
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
        $dumpvars(0,clk_ref, desired_freq, fractional_div, ref_freq, reset, clk_out);
    end

endmodule
