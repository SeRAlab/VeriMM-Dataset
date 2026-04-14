`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    reg load;
    reg [1:0] shift;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .load(load),
        .shift(shift),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load = 1;
            data = 4'b0000;
            shift = 2'b00;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1; data = 4'b1010;
            @(posedge clk);
            #1;

            load = 0; shift = 2'b00;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Load 1010, Shift 00 (No Shift)", test_num);
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1; data = 4'b1011;
            @(posedge clk);
            #1;

            load = 0; shift = 2'b01; data = 4'b0111;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Load 1011, Shift 01 (Left 1, Fill LSB with data[3]=0)", test_num);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1; data = 4'b1011;
            @(posedge clk);
            #1;

            load = 0; shift = 2'b10; data = 4'b1111;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Load 1011, Shift 10 (Right 1, Fill MSB with data[0]=1)", test_num);
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1; data = 4'b1100;
            @(posedge clk);
            #1;

            load = 0; shift = 2'b11; data = 4'b0001;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Load 1100, Shift 11 (Right 2, Fill MSBs with data[1:0]=01)", test_num);
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1; data = 4'b0001;
            @(posedge clk);
            #1;

            load = 0; shift = 2'b01; data = 4'b1000;
            @(posedge clk);
            #1;

            load = 0; shift = 2'b01; data = 4'b1000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Consecutive Left Shifts", test_num);
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1; data = 4'b1111; shift = 2'b11;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Load Priority Over Shift", test_num);
            #1;

            check_outputs(4'b1111);
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
        input [3:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, data, load, shift, result);
    end

endmodule
