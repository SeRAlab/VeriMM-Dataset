`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CaptureDR;
    reg FromCore;
    reg FromOutputEnable;
    reg FromPreviousBSCell;
    reg ShiftDR;
    reg TCK;
    reg UpdateDR;
    reg extest;
    wire BiDirPin;
    wire ToCore;
    wire ToNextBSCell;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CaptureDR(CaptureDR),
        .FromCore(FromCore),
        .FromOutputEnable(FromOutputEnable),
        .FromPreviousBSCell(FromPreviousBSCell),
        .ShiftDR(ShiftDR),
        .TCK(TCK),
        .UpdateDR(UpdateDR),
        .extest(extest),
        .BiDirPin(BiDirPin),
        .ToCore(ToCore),
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
            FromCore = 0;
            FromOutputEnable = 0;
            FromPreviousBSCell = 0;
            ShiftDR = 0;
            UpdateDR = 0;
            extest = 0;
            BiDirPin_driver_en = 0;
            BiDirPin_driver_val = 0;
            #15;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Capture from Core");
            reset_dut();
            FromCore = 1;
            CaptureDR = 1;
            ShiftDR = 0;
            @(posedge TCK);
            #2;

            #1;


            check_outputs(1'bz, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Shift from Previous Cell");
            reset_dut();
            FromPreviousBSCell = 1;
            ShiftDR = 1;
            CaptureDR = 0;
            @(posedge TCK);
            #2;

            #1;


            check_outputs(1'bz, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Update and Drive Pin (EXTEST)");
            reset_dut();

            FromPreviousBSCell = 1;
            ShiftDR = 1;
            @(posedge TCK); #2;
            ShiftDR = 0;

            UpdateDR = 1;
            @(posedge TCK); #2;
            UpdateDR = 0;

            extest = 1;
            FromOutputEnable = 1;
            #2;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Normal Mode (extest=0)");
            reset_dut();
            extest = 0;
            FromCore = 0;
            FromOutputEnable = 1;
            #5;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0);

            FromCore = 1;
            #5;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: BiDirPin Tri-state");
            reset_dut();
            extest = 1;
            FromOutputEnable = 0;

            BiDirPin_driver_en = 1;
            BiDirPin_driver_val = 1;
            #10;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0);
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
        input expected_BiDirPin;
        input expected_ToCore;
        input expected_ToNextBSCell;
        begin
            if (expected_BiDirPin === (expected_BiDirPin ^ BiDirPin ^ expected_BiDirPin) &&
                expected_ToCore === (expected_ToCore ^ ToCore ^ expected_ToCore) &&
                expected_ToNextBSCell === (expected_ToNextBSCell ^ ToNextBSCell ^ expected_ToNextBSCell)) begin
                $display("PASS");
                $display("  Outputs: BiDirPin=%b, ToCore=%b, ToNextBSCell=%b",
                         BiDirPin, ToCore, ToNextBSCell);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BiDirPin=%b, ToCore=%b, ToNextBSCell=%b",
                         expected_BiDirPin, expected_ToCore, expected_ToNextBSCell);
                $display("  Got:      BiDirPin=%b, ToCore=%b, ToNextBSCell=%b",
                         BiDirPin, ToCore, ToNextBSCell);
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
        $dumpvars(0,CaptureDR, FromCore, FromOutputEnable, FromPreviousBSCell, ShiftDR, TCK, UpdateDR, extest, BiDirPin, ToCore, ToNextBSCell);
    end

endmodule
