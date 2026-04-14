`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg reset;
    reg select;
    reg up_down;
    wire [3:0] shifted_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .select(select),
        .up_down(up_down),
        .shifted_count(shifted_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            up_down = 0;
            select = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset");
            reset_dut();

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Load 4'b1010");
            reset_dut();
            data_in = 4'b1010;
            load = 1;
            select = 0;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Increment");
            reset_dut();
            up_down = 1;
            load = 0;
            select = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Decrement (Wrap 0 to 15)");
            reset_dut();
            up_down = 0;
            load = 0;
            select = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Increment Wrap (15 to 0)");
            reset_dut();
            data_in = 4'b1111;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            up_down = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Barrel Shift (4'b1000 -> 4'b0001)");
            reset_dut();
            data_in = 4'b1000;
            load = 1;
            select = 0;
            @(posedge clk);
            #1;
            load = 0;
            select = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Barrel Shift (4'b0101 -> 4'b1010)");
            reset_dut();
            data_in = 4'b0101;
            load = 1;
            select = 0;
            @(posedge clk);
            #1;
            load = 0;
            select = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1010);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Inc + Shift (1 -> 2 -> 4)");
            reset_dut();
            data_in = 4'b0001;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            up_down = 1;
            select = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase009;

        begin
            $display("Running testcase009: Dec + Shift (4 -> 3 -> 6)");
            reset_dut();
            data_in = 4'b0100;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            up_down = 0;
            select = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase010;

        begin
            $display("Running testcase010: Load + Shift (8 -> 1)");
            reset_dut();
            data_in = 4'b1000;
            load = 1;
            select = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'b0001);
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
        testcase010();
        
        
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
        input [3:0] expected_shifted_count;
        begin
            if (expected_shifted_count === (expected_shifted_count ^ shifted_count ^ expected_shifted_count)) begin
                $display("PASS");
                $display("  Outputs: shifted_count=%h",
                         shifted_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted_count=%h",
                         expected_shifted_count);
                $display("  Got:      shifted_count=%h",
                         shifted_count);
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
        $dumpvars(0,clk, data_in, load, reset, select, up_down, shifted_count);
    end

endmodule
