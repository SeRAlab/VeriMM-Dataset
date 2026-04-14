`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] ctrl;
    reg [1:0] data;
    reg we;
    wire [1:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .data(data),
        .we(we),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        we = 0;
        forever #5 we = ~we;
    end

        task reset_dut;

        begin
            ctrl = 4'b0000;
            data = 2'b00;
            @(posedge we);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: All control bits enabled", test_num);
            ctrl = 4'b1111;
            data = 2'b11;
            @(posedge we);
            #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: All control bits disabled", test_num);
            ctrl = 4'b0000;
            data = 2'b11;
            @(posedge we);
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Only bit 0 enabled", test_num);
            ctrl = 4'b0001;
            data = 2'b11;
            @(posedge we);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Only bit 1 enabled", test_num);
            ctrl = 4'b0010;
            data = 2'b11;
            @(posedge we);
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Pattern bitwise AND", test_num);
            ctrl = 4'b0011;
            data = 2'b01;
            @(posedge we);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Data change while control is latched", test_num);
            ctrl = 4'b0010;
            data = 2'b11;
            @(posedge we);
            #2;
            data = 2'b01;
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Verify latching behavior (no edge)", test_num);
            ctrl = 4'b0011;
            data = 2'b11;
            @(posedge we);
            #2;
            ctrl = 4'b0000;
            #1;
            #1;

            check_outputs(2'b11);
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
        input [1:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,ctrl, data, we, out);
    end

endmodule
