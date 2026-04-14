`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] HEX0;
    reg [6:0] HEX1;
    reg [6:0] HEX2;
    reg [6:0] HEX3;
    reg clk;
    wire [3:0] DISPn;
    wire [6:0] HEX;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .clk(clk),
        .DISPn(DISPn),
        .HEX(HEX)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin
            HEX0 = 7'h11;
            HEX1 = 7'h22;
            HEX2 = 7'h33;
            HEX3 = 7'h44;
            #1;


            for (i = 0; i < 4; i = i + 1) begin
                if (DISPn !== 4'b1110) begin
                    @(posedge clk);
                    #2;
                end
            end
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Verify Digit 0 (HEX0)...");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'b1110, 7'h11);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Verify Digit 1 (HEX1)...");
            test_num = 2;
            reset_dut();
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1101, 7'h22);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Verify Digit 2 (HEX2)...");
            test_num = 3;
            reset_dut();
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1011, 7'h33);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Verify Digit 3 (HEX3)...");
            test_num = 4;
            reset_dut();
            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0111, 7'h44);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Verify FSM Wrap-around back to Digit 0...");
            test_num = 5;
            reset_dut();
            repeat(4) @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1110, 7'h11);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Verify Output updates when input HEX changes...");
            test_num = 6;
            reset_dut();
            HEX2 = 7'h7F;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1011, 7'h7F);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Verify persistence of other inputs...");
            test_num = 7;
            reset_dut();
            HEX0 = 7'h00;
            HEX1 = 7'h5A;
            HEX2 = 7'h00;
            HEX3 = 7'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1101, 7'h5A);
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
        input [3:0] expected_DISPn;
        input [6:0] expected_HEX;
        begin
            if (expected_DISPn === (expected_DISPn ^ DISPn ^ expected_DISPn) &&
                expected_HEX === (expected_HEX ^ HEX ^ expected_HEX)) begin
                $display("PASS");
                $display("  Outputs: DISPn=%h, HEX=%h",
                         DISPn, HEX);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DISPn=%h, HEX=%h",
                         expected_DISPn, expected_HEX);
                $display("  Got:      DISPn=%h, HEX=%h",
                         DISPn, HEX);
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
        $dumpvars(0,HEX0, HEX1, HEX2, HEX3, clk, DISPn, HEX);
    end

endmodule
