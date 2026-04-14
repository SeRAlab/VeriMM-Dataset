`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg count_enable;
    reg load;
    reg up_down;
    wire [3:0] count;
    wire max_reached;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .count_enable(count_enable),
        .load(load),
        .up_down(up_down),
        .count(count),
        .max_reached(max_reached)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 0;
            load = 0;
            count_enable = 0;
            up_down = 1;
            #12;
            areset = 1;
            #8;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            count_enable = 1;
            up_down = 1;
            repeat(15) @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk);
            count_enable = 1;
            up_down = 1;
            repeat(16) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(posedge clk);
            count_enable = 1;
            up_down = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(posedge clk);
            count_enable = 1;
            up_down = 1;
            repeat(5) @(posedge clk);
            count_enable = 0;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h5, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            @(posedge clk);
            count_enable = 1;
            up_down = 1;
            repeat(10) @(posedge clk);

            up_down = 0;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h7, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [3:0] expected_count;
        input expected_max_reached;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_max_reached === (expected_max_reached ^ max_reached ^ expected_max_reached)) begin
                $display("PASS");
                $display("  Outputs: count=%h, max_reached=%b",
                         count, max_reached);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, max_reached=%b",
                         expected_count, expected_max_reached);
                $display("  Got:      count=%h, max_reached=%b",
                         count, max_reached);
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
        $dumpvars(0,areset, clk, count_enable, load, up_down, count, max_reached);
    end

endmodule
