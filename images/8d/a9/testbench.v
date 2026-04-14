`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg freeze;
    reg [1:0] tach;
    wire down;
    wire up;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .freeze(freeze),
        .tach(tach),
        .down(down),
        .up(up)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            freeze = 0;
            tach = 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            tach = 2'b01;
            @(posedge clk);
            #1;
            $display("Test %0d: Up transition (00 -> 01)", test_num);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();

            tach = 2'b01;
            @(posedge clk);
            #1;

            tach = 2'b11;
            @(posedge clk);
            #1;
            $display("Test %0d: Up transition (01 -> 11)", test_num);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            tach = 2'b01; @(posedge clk); #1;
            tach = 2'b11; @(posedge clk); #1;

            tach = 2'b10;
            @(posedge clk);
            #1;
            $display("Test %0d: Up transition (11 -> 10)", test_num);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            tach = 2'b10;
            @(posedge clk);
            #1;
            $display("Test %0d: Down transition (00 -> 10)", test_num);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            tach = 2'b10;
            @(posedge clk);
            #1;

            tach = 2'b11;
            @(posedge clk);
            #1;
            $display("Test %0d: Down transition (10 -> 11)", test_num);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            freeze = 1;
            tach = 2'b01;
            @(posedge clk);
            #1;
            $display("Test %0d: Freeze active (00 -> 01)", test_num);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            tach = 2'b00;
            @(posedge clk);
            #1;
            $display("Test %0d: No tach change (00 -> 00)", test_num);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            tach = 2'b11;
            @(posedge clk);
            #1;
            $display("Test %0d: Invalid transition (00 -> 11)", test_num);
            #1;

            check_outputs(0, 0);
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
        input expected_down;
        input expected_up;
        begin
            if (expected_down === (expected_down ^ down ^ expected_down) &&
                expected_up === (expected_up ^ up ^ expected_up)) begin
                $display("PASS");
                $display("  Outputs: down=%b, up=%b",
                         down, up);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: down=%b, up=%b",
                         expected_down, expected_up);
                $display("  Got:      down=%b, up=%b",
                         down, up);
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
        $dumpvars(0,clk, freeze, tach, down, up);
    end

endmodule
