`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg [3:0] data;
    reg ena;
    reg load;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            load = 0;
            ena = 0;
            data = 0;
            #12;
            areset = 0;
            #8;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            load <= 1;
            data <= 4'b1011;
            @(posedge clk);
            load <= 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk);
            load <= 1;
            data <= 4'b1000;
            @(posedge clk);
            load <= 0;
            ena <= 1;
            @(posedge clk);
            ena <= 0;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(posedge clk);
            load <= 1;
            data <= 4'b1111;
            @(posedge clk);
            load <= 0;
            ena <= 1;
            repeat (4) @(posedge clk);
            ena <= 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(posedge clk);
            load <= 1;
            data <= 4'b0101;
            @(posedge clk);
            load <= 0;
            ena <= 0;
            repeat (2) @(posedge clk);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(posedge clk);
            load <= 1;
            data <= 4'b1010;
            @(posedge clk);

            load <= 1;
            ena <= 1;
            data <= 4'b0011;
            @(posedge clk);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            @(posedge clk);
            load <= 1;
            data <= 4'b1111;
            @(posedge clk);
            load <= 0;
            ena <= 1;
            @(posedge clk);
            #2 areset = 1;
            #1 #1;
 check_outputs(4'b0000);
            areset = 0;
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
        testcase007();
        
        
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,areset, clk, data, ena, load, q);
    end

endmodule
