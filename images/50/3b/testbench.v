`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    reg [1:0] s;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .s(s),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Select s=0, in[0]=0");
            in = 4'b1110;
            s  = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Select s=0, in[0]=1");
            in = 4'b0001;
            s  = 2'b00;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Select s=1, in[1]=0");
            in = 4'b1101;
            s  = 2'b01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Select s=1, in[1]=1");
            in = 4'b0010;
            s  = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Select s=2, in[2]=0");
            in = 4'b1011;
            s  = 2'b10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Select s=2, in[2]=1");
            in = 4'b0100;
            s  = 2'b10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Select s=3, in[3]=0");
            in = 4'b0111;
            s  = 2'b11;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Select s=3, in[3]=1");
            in = 4'b1000;
            s  = 2'b11;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: All inputs 1, select s=1");
            in = 4'b1111;
            s  = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: All inputs 0, select s=2");
            in = 4'b0000;
            s  = 2'b10;
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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

endmodule
