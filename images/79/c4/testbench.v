`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] datain;
    reg reset_n;
    reg [1:0] shift_by;
    wire [7:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .datain(datain),
        .reset_n(reset_n),
        .shift_by(shift_by),
        .dataout(dataout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            datain = 8'h00;
            shift_by = 2'b00;
            @(posedge clk);
            #1;
            reset_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Checking Synchronous Reset...");
            reset_n = 0;
            datain = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
            reset_n = 1;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: No Shift (shift_by = 00)");
            reset_dut();
            datain = 8'hA5;
            shift_by = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Shift Left by 1 (shift_by = 01)");
            reset_dut();
            datain = 8'h55;
            shift_by = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Shift Right by 1 (shift_by = 10)");
            reset_dut();
            datain = 8'hAA;
            shift_by = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Shift Left by 2 (shift_by = 11)");
            reset_dut();
            datain = 8'h0F;
            shift_by = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Shift Left MSB overflow");
            reset_dut();
            datain = 8'h81;
            shift_by = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Shift Right LSB underflow");
            reset_dut();
            datain = 8'h81;
            shift_by = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Continuous shifting sequence");
            reset_dut();


            datain = 8'hFF;
            shift_by = 2'b11;
            @(posedge clk);
            #1;


            datain = 8'h12;
            shift_by = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h24);
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
        input [7:0] expected_dataout;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h",
                         expected_dataout);
                $display("  Got:      dataout=%h",
                         dataout);
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
        $dumpvars(0,clk, datain, reset_n, shift_by, dataout);
    end

endmodule
