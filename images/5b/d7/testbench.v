`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dataIn;
    reg [1:0] raAddress;
    reg [1:0] rbAddress;
    reg regWrite;
    reg reset;
    wire [7:0] regA;
    wire [7:0] regB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dataIn(dataIn),
        .raAddress(raAddress),
        .rbAddress(rbAddress),
        .regWrite(regWrite),
        .reset(reset),
        .regA(regA),
        .regB(regB)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            regWrite = 0;
            dataIn = 0;
            raAddress = 0;
            rbAddress = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset Check");
            test_num = 1;
            reset_dut();


            raAddress = 2'b00; rbAddress = 2'b01;
            #5;
            if (regA !== 8'h00 || regB !== 8'h00) begin
                #1;

                check_outputs(8'h00, 8'h00);
            end else begin
                raAddress = 2'b10; rbAddress = 2'b11;
                #5;
                #1;

                check_outputs(8'h00, 8'h00);
            end
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Write to Reg 0");
            test_num = 2;
            reset_dut();

            raAddress = 2'b00;
            dataIn = 8'hA5;
            regWrite = 1;

            @(negedge clk);
            #2 regWrite = 0;

            raAddress = 2'b00;
            rbAddress = 2'b00;
            #5;
            #1;

            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Write to Reg 3, Read RB");
            test_num = 3;
            reset_dut();

            raAddress = 2'b11;
            dataIn = 8'h5A;
            regWrite = 1;

            @(negedge clk);
            #2 regWrite = 0;

            raAddress = 2'b00;
            rbAddress = 2'b11;
            #5;
            #1;

            check_outputs(8'h00, 8'h5A);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Write Enable Check");
            test_num = 4;
            reset_dut();

            raAddress = 2'b01;
            dataIn = 8'hFF;
            regWrite = 0;

            @(negedge clk);
            #5;
            raAddress = 2'b01;
            rbAddress = 2'b01;
            #5;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Multi-register storage check");
            test_num = 5;
            reset_dut();


            raAddress = 2'b01; dataIn = 8'h11; regWrite = 1;
            @(negedge clk);


            raAddress = 2'b10; dataIn = 8'h22; regWrite = 1;
            @(negedge clk);

            #2 regWrite = 0;
            raAddress = 2'b01;
            rbAddress = 2'b10;
            #5;
            #1;

            check_outputs(8'h11, 8'h22);
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
        input [7:0] expected_regA;
        input [7:0] expected_regB;
        begin
            if (expected_regA === (expected_regA ^ regA ^ expected_regA) &&
                expected_regB === (expected_regB ^ regB ^ expected_regB)) begin
                $display("PASS");
                $display("  Outputs: regA=%h, regB=%h",
                         regA, regB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: regA=%h, regB=%h",
                         expected_regA, expected_regB);
                $display("  Got:      regA=%h, regB=%h",
                         regA, regB);
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
        $dumpvars(0,clk, dataIn, raAddress, rbAddress, regWrite, reset, regA, regB);
    end

endmodule
