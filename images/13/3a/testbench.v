`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [1:0] voltage_level;
    wire freq_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .clk(clk),
        .reset(reset),
        .voltage_level(voltage_level),
        .freq_out(freq_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\n[Task] Resetting DUT...");
            reset = 1;
            voltage_level = 2'b00;
            repeat(5) @(posedge clk);
            #2;
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Default Frequency (200MHz)", test_num);


            reset = 1;
            voltage_level = 2'b00;
            #20;


            @(posedge freq_out);
            t_start = $realtime;
            @(posedge freq_out);
            t_end = $realtime;
            measured_period = t_end - t_start;

            $display("  Measured Period: %0.3f ns (Expected: 5.000 ns)", measured_period);


            @(posedge freq_out);
            #2.5;
            #1;

            check_outputs(0);
            #2.5;
            #1;

            check_outputs(1);

            reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 1.0V Level (200MHz)", test_num);
            reset_dut();

            voltage_level = 2'b10;
            repeat(10) @(posedge clk);

            @(posedge freq_out);
            t_start = $realtime;
            @(posedge freq_out);
            t_end = $realtime;
            measured_period = t_end - t_start;

            $display("  Measured Period: %0.3f ns", measured_period);


            @(posedge freq_out);
            #2.5;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 0.9V Level (150MHz)", test_num);
            reset_dut();

            voltage_level = 2'b01;
            repeat(10) @(posedge clk);

            @(posedge freq_out);
            t_start = $realtime;
            @(posedge freq_out);
            t_end = $realtime;
            measured_period = t_end - t_start;

            $display("  Measured Period: %0.3f ns", measured_period);


            @(posedge freq_out);
            #(6.667 / 2.0);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 0.8V Level (100MHz)", test_num);
            reset_dut();

            voltage_level = 2'b00;
            repeat(10) @(posedge clk);

            @(posedge freq_out);
            t_start = $realtime;
            @(posedge freq_out);
            t_end = $realtime;
            measured_period = t_end - t_start;

            $display("  Measured Period: %0.3f ns", measured_period);

            @(posedge freq_out);
            #5.0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Dynamic Scaling (1.0V -> 0.8V)", test_num);
            reset_dut();


            voltage_level = 2'b10;
            repeat(5) @(posedge freq_out);


            voltage_level = 2'b00;
            repeat(5) @(posedge freq_out);


            @(posedge freq_out);
            t_start = $realtime;
            @(posedge freq_out);
            t_end = $realtime;
            measured_period = t_end - t_start;

            $display("  Targeting 100MHz. Measured Period: %0.3f ns", measured_period);


            @(posedge freq_out);
            #5.0;
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dvfs_controller Testbench");
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
        input expected_freq_out;
        begin
            if (expected_freq_out === (expected_freq_out ^ freq_out ^ expected_freq_out)) begin
                $display("PASS");
                $display("  Outputs: freq_out=%b",
                         freq_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: freq_out=%b",
                         expected_freq_out);
                $display("  Got:      freq_out=%b",
                         freq_out);
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
        $dumpvars(0,clk, reset, voltage_level, freq_out);
    end

endmodule
