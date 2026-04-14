`timescale 1ns/1ps

module monte_carlo_simulation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] num_samples;
    wire [15:0] average;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    monte_carlo_simulation dut (
        .clk(clk),
        .num_samples(num_samples),
        .average(average)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            num_samples = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\n[Testcase %03d] Starting: Minimum Samples (N=1)", test_num);
            reset_dut();
            num_samples = 8'd1;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h007F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\n[Testcase %03d] Starting: Power of Two (N=16)", test_num);
            reset_dut();
            num_samples = 8'd16;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(16'h0082);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\n[Testcase %03d] Starting: Mid-Range (N=100)", test_num);
            reset_dut();
            num_samples = 8'd100;
            repeat(110) @(posedge clk);
            #1;

            check_outputs(16'h007E);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\n[Testcase %03d] Starting: Max Capacity (N=255)", test_num);
            reset_dut();
            num_samples = 8'd255;
            repeat(265) @(posedge clk);
            #1;

            check_outputs(16'h0080);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("monte_carlo_simulation Testbench");
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
        input [15:0] expected_average;
        begin
            if (expected_average === (expected_average ^ average ^ expected_average)) begin
                $display("PASS");
                $display("  Outputs: average=%h",
                         average);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: average=%h",
                         expected_average);
                $display("  Got:      average=%h",
                         average);
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
        $dumpvars(0,clk, num_samples, average);
    end

endmodule
