`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg [3:0] div_ratio;
    reg reset;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .clk_in(clk_in),
        .div_ratio(div_ratio),
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
            $display("Resetting the system...");
            reset = 1;
            div_ratio = 4'b0000;
            #100;
            reset = 0;
            #100;
        end
        endtask
    task testcase001;

        real t_start, t_end, measured_period, expected_period;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing div_ratio = 2", test_num);
            reset_dut();


            div_ratio = 4'd2;


            #50000;


            @(posedge clk_out);
            t_start = $realtime;
            @(posedge clk_out);
            t_end = $realtime;
            measured_period = t_end - t_start;



            expected_period = 10.0 / 2.0;

            $display("  Measured Period: %0t ps", measured_period * 1000);
            $display("  Expected Period: %0t ps", expected_period * 1000);


            if (measured_period >= expected_period * 0.95 && measured_period <= expected_period * 1.05)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(~clk_out);
        end
        endtask

    task testcase002;

        real t_start, t_end, measured_period, expected_period;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing div_ratio = 5", test_num);
            reset_dut();

            div_ratio = 4'd5;

            #50000;

            @(posedge clk_out);
            t_start = $realtime;
            @(posedge clk_out);
            t_end = $realtime;
            measured_period = t_end - t_start;


            expected_period = 10.0 / 5.0;

            $display("  Measured Period: %0t ps", measured_period * 1000);
            $display("  Expected Period: %0t ps", expected_period * 1000);

            if (measured_period >= expected_period * 0.95 && measured_period <= expected_period * 1.05)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(~clk_out);
        end
        endtask

    task testcase003;

        real t_start, t_end, measured_period, expected_period;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing div_ratio = 8", test_num);
            reset_dut();

            div_ratio = 4'd8;

            #50000;

            @(posedge clk_out);
            t_start = $realtime;
            @(posedge clk_out);
            t_end = $realtime;
            measured_period = t_end - t_start;


            expected_period = 10.0 / 8.0;

            $display("  Measured Period: %0t ps", measured_period * 1000);
            $display("  Expected Period: %0t ps", expected_period * 1000);

            if (measured_period >= expected_period * 0.95 && measured_period <= expected_period * 1.05)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(~clk_out);
        end
        endtask

    task testcase004;

        real t_start, t_end, measured_period, expected_period;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing div_ratio = 15", test_num);
            reset_dut();

            div_ratio = 4'd15;

            #50000;

            @(posedge clk_out);
            t_start = $realtime;
            @(posedge clk_out);
            t_end = $realtime;
            measured_period = t_end - t_start;


            expected_period = 10.0 / 15.0;

            $display("  Measured Period: %0t ps", measured_period * 1000);
            $display("  Expected Period: %0t ps", expected_period * 1000);

            if (measured_period >= expected_period * 0.95 && measured_period <= expected_period * 1.05)
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
        $dumpvars(0,clk_in, div_ratio, reset, clk_out);
    end

endmodule
