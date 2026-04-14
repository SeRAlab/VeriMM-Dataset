`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i0;
    reg i1;
    reg i2;
    reg i3;
    reg [1:0] sel;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i0(i0),
        .i1(i1),
        .i2(i2),
        .i3(i3),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            $display("Testcase 001: Select i0 (sel=00), i0=1");
            test_num = 1;
            i0 = 1; i1 = 0; i2 = 0; i3 = 0;
            sel = 2'b00;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Select i0 (sel=00), i0=0");
            test_num = 2;
            i0 = 0; i1 = 1; i2 = 1; i3 = 1;
            sel = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Select i1 (sel=01), i1=1");
            test_num = 3;
            i0 = 0; i1 = 1; i2 = 0; i3 = 0;
            sel = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Select i1 (sel=01), i1=0");
            test_num = 4;
            i0 = 1; i1 = 0; i2 = 1; i3 = 1;
            sel = 2'b01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Select i2 (sel=10), i2=1");
            test_num = 5;
            i0 = 0; i1 = 0; i2 = 1; i3 = 0;
            sel = 2'b10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Select i2 (sel=10), i2=0");
            test_num = 6;
            i0 = 1; i1 = 1; i2 = 0; i3 = 1;
            sel = 2'b10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Select i3 (sel=11), i3=1");
            test_num = 7;
            i0 = 0; i1 = 0; i2 = 0; i3 = 1;
            sel = 2'b11;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Select i3 (sel=11), i3=0");
            test_num = 8;
            i0 = 1; i1 = 1; i2 = 1; i3 = 0;
            sel = 2'b11;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: All inputs high, switching select");
            test_num = 9;
            i0 = 1; i1 = 1; i2 = 1; i3 = 1;
            sel = 2'b10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: All inputs low, switching select");
            test_num = 10;
            i0 = 0; i1 = 0; i2 = 0; i3 = 0;
            sel = 2'b01;
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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

endmodule
