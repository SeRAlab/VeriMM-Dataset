`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Reset;
    reg Up_Down;
    reg clk;
    reg [2:0] counter_in;
    wire [4:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Reset(Reset),
        .Up_Down(Up_Down),
        .clk(clk),
        .counter_in(counter_in),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            counter_in = 3'b000;
            Up_Down = 1;
            @(posedge clk);
            #1;
            Reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior (Counter=0)", test_num);
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            Up_Down = 1;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Testcase %0d: Up Count to 1", test_num);
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            Up_Down = 1;
            repeat(2) @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Testcase %0d: Up Count to 2", test_num);
            #1;

            check_outputs(5'd2);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            Up_Down = 1;
            repeat(3) @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Testcase %0d: Up Count to 3", test_num);
            #1;

            check_outputs(5'd4);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            Up_Down = 1;
            repeat(4) @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Testcase %0d: Up Count to 4", test_num);
            #1;

            check_outputs(5'd4);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            Up_Down = 1;
            repeat(5) @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Testcase %0d: Up Count to 5", test_num);
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            Up_Down = 1;
            repeat(7) @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Testcase %0d: Up Count to 7", test_num);
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            Up_Down = 1;
            repeat(8) @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Testcase %0d: Up Count Roll-over (7 to 0)", test_num);
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            Up_Down = 0;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Testcase %0d: Down Count (0 to 7)", test_num);
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            Up_Down = 0;
            repeat(4) @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Testcase %0d: Down Count to 4", test_num);
            #1;

            check_outputs(5'd4);
        end
        endtask

    task testcase011;

        begin
            reset_dut();
            Up_Down = 0;
            repeat(7) @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Testcase %0d: Down Count to 1", test_num);
            #1;

            check_outputs(5'd1);
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
        testcase011();
        
        
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
        input [4:0] expected_result;
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
        $dumpvars(0,Reset, Up_Down, clk, counter_in, result);
    end

endmodule
