`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg [15:0] data_in_port1;
    reg write_en_port1;
    wire X;
    wire [15:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .data_in_port1(data_in_port1),
        .write_en_port1(write_en_port1),
        .X(X),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        write_en_port1 = 0;
        forever #5 write_en_port1 = ~write_en_port1;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            data_in_port1 = 0;

            #10;
        end
        endtask
    task write_mem;

        input addr_A;
        input addr_B;
        input [15:0] data;
        begin
            A = addr_A;
            B = addr_B;
            data_in_port1 = data;

            @(posedge write_en_port1);
            #2;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Writing 0x0001 to Address 0 (A=0, B=0)");
            write_mem(0, 0, 16'h0001);
            #1;

            check_outputs(1'b1, 16'hFFFD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Writing 0x0000 to Address 1 (A=0, B=1)");
            write_mem(0, 1, 16'h0000);
            #1;

            check_outputs(1'b0, 16'hFFFE);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Writing 0x0004 to Address 2 (A=1, B=0)");
            write_mem(1, 0, 16'h0004);
            #1;

            check_outputs(1'b0, 16'hFFEF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Writing 0x000F to Address 3 (A=1, B=1)");
            write_mem(1, 1, 16'h000F);
            #1;

            check_outputs(1'b1, 16'h7FFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Checking persistence of Address 0");
            A = 0; B = 0;
            #10;
            #1;

            check_outputs(1'b1, 16'hFFFD);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Writing 0x000B to Address 2 (A=1, B=0)");
            write_mem(1, 0, 16'h000B);
            #1;

            check_outputs(1'b1, 16'hF7FF);
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
        input expected_X;
        input [15:0] expected_Y;
        begin
            if (expected_X === (expected_X ^ X ^ expected_X) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: X=%b, Y=%h",
                         X, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b, Y=%h",
                         expected_X, expected_Y);
                $display("  Got:      X=%b, Y=%h",
                         X, Y);
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
        $dumpvars(0,A, B, data_in_port1, write_en_port1, X, Y);
    end

endmodule
