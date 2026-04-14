`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CaptureDR;
    reg FromPreviousBSCell;
    reg InputPin;
    reg ShiftDR;
    reg TCK;
    wire ToNextBSCell;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CaptureDR(CaptureDR),
        .FromPreviousBSCell(FromPreviousBSCell),
        .InputPin(InputPin),
        .ShiftDR(ShiftDR),
        .TCK(TCK),
        .ToNextBSCell(ToNextBSCell)
    );

    // Clock generation (10ns period)
    initial begin
        TCK = 0;
        forever #5 TCK = ~TCK;
    end

        task reset_dut;

        begin
            CaptureDR = 0;
            FromPreviousBSCell = 0;
            InputPin = 0;
            ShiftDR = 0;

            @(negedge TCK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Capture External Pin (1)", test_num);
            reset_dut();
            InputPin = 1;
            CaptureDR = 1;
            ShiftDR = 0;
            @(negedge TCK);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Capture External Pin (0)", test_num);
            reset_dut();
            InputPin = 0;
            CaptureDR = 1;
            ShiftDR = 0;


            FromPreviousBSCell = 1; ShiftDR = 1; @(negedge TCK);

            InputPin = 0; CaptureDR = 1; ShiftDR = 0;
            @(negedge TCK);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Shift from Previous BSCell (1)", test_num);
            reset_dut();
            FromPreviousBSCell = 1;
            ShiftDR = 1;
            CaptureDR = 0;
            @(negedge TCK);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Shift from Previous BSCell (0)", test_num);
            reset_dut();

            FromPreviousBSCell = 1; ShiftDR = 1; @(negedge TCK);

            FromPreviousBSCell = 0; ShiftDR = 1; CaptureDR = 0;
            @(negedge TCK);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Shift priority over Capture", test_num);
            reset_dut();
            FromPreviousBSCell = 1;
            InputPin = 0;
            ShiftDR = 1;
            CaptureDR = 1;
            @(negedge TCK);
            #1;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Hold Data (No Capture/Shift)", test_num);
            reset_dut();

            InputPin = 1; CaptureDR = 1; ShiftDR = 0;
            @(negedge TCK);

            CaptureDR = 0; ShiftDR = 0; InputPin = 0; FromPreviousBSCell = 0;
            @(negedge TCK);
            #1;

            #1;


            check_outputs(1);
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
        input expected_ToNextBSCell;
        begin
            if (expected_ToNextBSCell === (expected_ToNextBSCell ^ ToNextBSCell ^ expected_ToNextBSCell)) begin
                $display("PASS");
                $display("  Outputs: ToNextBSCell=%b",
                         ToNextBSCell);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ToNextBSCell=%b",
                         expected_ToNextBSCell);
                $display("  Got:      ToNextBSCell=%b",
                         ToNextBSCell);
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
        $dumpvars(0,CaptureDR, FromPreviousBSCell, InputPin, ShiftDR, TCK, ToNextBSCell);
    end

endmodule
