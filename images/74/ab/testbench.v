`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg fully_closed;
    reg fully_open;
    reg sensor;
    wire gate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .fully_closed(fully_closed),
        .fully_open(fully_open),
        .sensor(sensor),
        .gate(gate)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            sensor = 0;
            fully_open = 0;
            fully_closed = 0;
            #12;
            areset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            sensor = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            sensor = 1;
            @(posedge clk);
            fully_open = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            sensor = 1; @(posedge clk);
            fully_open = 1; @(posedge clk);
            sensor = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            sensor = 1; @(posedge clk);
            fully_open = 1; @(posedge clk);
            sensor = 0; @(posedge clk);
            fully_closed = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            sensor = 1;
            @(posedge clk);
            fully_open = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            sensor = 1; @(posedge clk);
            fully_open = 1; @(posedge clk);
            sensor = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            sensor = 1; @(posedge clk);
            fully_open = 1; @(posedge clk);
            sensor = 0; @(posedge clk);
            fully_closed = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            sensor = 1; @(posedge clk);
            fully_open = 1; @(posedge clk);
            #1;
            areset = 1;
            #2;
            #1;

            check_outputs(1'b0);
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
        testcase008();
        testcase009();
        
        
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
        input expected_gate;
        begin
            if (expected_gate === (expected_gate ^ gate ^ expected_gate)) begin
                $display("PASS");
                $display("  Outputs: gate=%b",
                         gate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gate=%b",
                         expected_gate);
                $display("  Got:      gate=%b",
                         gate);
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
        $dumpvars(0,areset, clk, fully_closed, fully_open, sensor, gate);
    end

endmodule
