`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] rDest;
    reg [2:0] rSrc;
    reg reset;
    reg [7:0] writeData;
    reg write_reg;
    wire [7:0] srcData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rDest(rDest),
        .rSrc(rSrc),
        .reset(reset),
        .writeData(writeData),
        .write_reg(write_reg),
        .srcData(srcData)
    );
    task testcase001;

        begin
            $display("Testcase 001: Check even-indexed register reset value (Reg 0)");
            test_num = 1;
            reset = 1;
            write_reg = 0;
            rSrc = 3'b000;
            #10;
            reset = 0;
            #10;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Check odd-indexed register reset value (Reg 1)");
            test_num = 2;
            reset = 1;
            write_reg = 0;
            rSrc = 3'b001;
            #10;
            reset = 0;
            #10;

            #1;


            check_outputs(8'h0A);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write to Reg 4 and read back");
            test_num = 3;
            reset = 1;
            #10;
            reset = 0;
            #10;
            rDest = 3'd4;
            writeData = 8'hAA;
            write_reg = 1;
            #10;
            write_reg = 0;
            rSrc = 3'd4;
            #10;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Attempt write with write_reg=0 (should not change)");
            test_num = 4;
            reset = 1;
            #10;
            reset = 0;
            #10;
            rDest = 3'd2;
            writeData = 8'hFF;
            write_reg = 0;
            #10;
            rSrc = 3'd2;
            #10;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Write to Reg 7 while reading Reg 0");
            test_num = 5;
            reset = 1;
            #10;
            reset = 0;
            #10;
            rDest = 3'd7;
            writeData = 8'h12;
            write_reg = 1;
            rSrc = 3'd0;
            #10;

            rSrc = 3'd7;
            #10;

            #1;


            check_outputs(8'h12);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Sequential write to Reg 6 then Reg 7");
            test_num = 6;
            reset = 1;
            #10;
            reset = 0;
            #10;

            rDest = 3'd6;
            writeData = 8'h66;
            write_reg = 1;
            #10;

            rDest = 3'd7;
            writeData = 8'h77;
            #10;
            write_reg = 0;

            rSrc = 3'd6;
            #10;
            #1;

            check_outputs(8'h66);
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
        input [7:0] expected_srcData;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_srcData === (expected_srcData ^ srcData ^ expected_srcData)) begin
                $display("PASS");
                $display("  Outputs: srcData=%h",
                         srcData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: srcData=%h",
                         expected_srcData);
                $display("  Got:      srcData=%h",
                         srcData);
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
