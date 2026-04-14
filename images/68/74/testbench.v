`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] in;
    wire [2:0] pedge;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .pedge(pedge)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 3'b000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit 0 -> 1 transition (bit 0)", test_num);
            reset_dut();
            in = 3'b000;
            @(posedge clk);
            in = 3'b001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All bits 0 -> 1 transition", test_num);
            reset_dut();
            in = 3'b000;
            @(posedge clk);
            in = 3'b111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Falling edge 1 -> 0 transition", test_num);
            reset_dut();
            in = 3'b111;
            @(posedge clk);
            in = 3'b000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Constant high signal", test_num);
            reset_dut();
            in = 3'b111;
            @(posedge clk);
            @(posedge clk);
            in = 3'b111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise independence (bit 1 transitions)", test_num);
            reset_dut();
            in = 3'b101;
            @(posedge clk);
            in = 3'b111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential transitions (bit 0 then bit 2)", test_num);
            reset_dut();
            in = 3'b000;
            @(posedge clk);
            in = 3'b001;
            @(posedge clk);
            in = 3'b101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rapid toggle 0 -> 1 -> 0", test_num);
            reset_dut();
            in = 3'b000;
            @(posedge clk);
            in = 3'b010;
            @(posedge clk);
            in = 3'b000;
            #2;
            #1;

            check_outputs(3'b010);
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
        input [2:0] expected_pedge;
        begin
            if (expected_pedge === (expected_pedge ^ pedge ^ expected_pedge)) begin
                $display("PASS");
                $display("  Outputs: pedge=%h",
                         pedge);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pedge=%h",
                         expected_pedge);
                $display("  Got:      pedge=%h",
                         pedge);
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
        $dumpvars(0,clk, in, pedge);
    end

endmodule
