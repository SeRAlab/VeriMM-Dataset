`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] dat;
    reg load;
    reg reset;
    reg shift;
    wire lastbit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dat(dat),
        .load(load),
        .reset(reset),
        .shift(shift),
        .lastbit(lastbit)
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
            shift = 0;
            dat = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Data 0x001", test_num);
            reset_dut();
            dat = 12'h001;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Data 0xAAA", test_num);
            reset_dut();
            dat = 12'hAAA;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Right with 1-fill (1 shift)", test_num);
            reset_dut();
            dat = 12'h000;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 1;
            @(posedge clk);
            #1;
            shift = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Right with 1-fill (11 shifts)", test_num);
            reset_dut();
            dat = 12'h000;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 1;
            repeat(11) @(posedge clk);
            #1;
            shift = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Right with 1-fill (12 shifts)", test_num);
            reset_dut();
            dat = 12'h000;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 1;
            repeat(12) @(posedge clk);
            #1;
            shift = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load 0x001 then Shift", test_num);
            reset_dut();
            dat = 12'h001;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 1;
            @(posedge clk);
            #1;
            shift = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset vs Load Priority", test_num);
            reset_dut();
            reset = 1;
            load = 1;
            dat = 12'hFFF;
            @(posedge clk);
            #1;
            reset = 0;
            load = 0;

            #1;


            check_outputs(1'b0);
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
        input expected_lastbit;
        begin
            if (expected_lastbit === (expected_lastbit ^ lastbit ^ expected_lastbit)) begin
                $display("PASS");
                $display("  Outputs: lastbit=%b",
                         lastbit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lastbit=%b",
                         expected_lastbit);
                $display("  Got:      lastbit=%b",
                         lastbit);
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
        $dumpvars(0,clk, dat, load, reset, shift, lastbit);
    end

endmodule
