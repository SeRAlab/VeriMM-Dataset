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
    wire ToNextBSCell;
    wire TristatedPin;

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
        .ToNextBSCell(ToNextBSCell),
        .TristatedPin(TristatedPin)
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

            repeat(2) @(posedge TCK);
            #1;
        end
        endtask
    task pulse_tck;

        begin
            #1;

            @(posedge TCK);
            #1;
        end
        endtask

    task pulse_update;

        begin
            UpdateDR = 0;
            #2;
            UpdateDR = 1;
            #10;
            UpdateDR = 0;
            #2;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transparent Mode (extest=0, OE=1)", test_num);
            extest = 0;
            FromOutputEnable = 1;
            FromCore = 1;
            #10;
            #1;

            check_outputs(1'bx, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Tristate in Normal Mode", test_num);
            extest = 0;
            FromOutputEnable = 0;
            FromCore = 1;
            #10;
            #1;

            check_outputs(1'bx, 1'bz);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Capture data from Core", test_num);
            FromCore = 1;
            CaptureDR = 1;
            ShiftDR = 0;
            pulse_tck();

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift data from previous cell", test_num);
            FromPreviousBSCell = 1;
            ShiftDR = 1;
            CaptureDR = 0;
            pulse_tck();
            #1;

            check_outputs(1'b1, 1'b0);

            FromPreviousBSCell = 0;
            pulse_tck();
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Update and Extest Mode", test_num);


            FromCore = 1;
            CaptureDR = 1;
            ShiftDR = 0;
            pulse_tck();


            pulse_update();


            extest = 1;
            FromOutputEnable = 1;
            FromCore = 0;
            #10;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift then Update", test_num);


            FromPreviousBSCell = 0;
            ShiftDR = 1;
            pulse_tck();


            pulse_update();


            extest = 1;
            FromOutputEnable = 1;
            #10;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Tristate in Extest Mode", test_num);


            FromPreviousBSCell = 1;
            ShiftDR = 1;
            pulse_tck();
            pulse_update();


            extest = 1;
            FromOutputEnable = 0;
            #10;

            #1;


            check_outputs(1'b1, 1'bz);
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
        input expected_ToNextBSCell;
        input expected_TristatedPin;
        begin
            if (expected_ToNextBSCell === (expected_ToNextBSCell ^ ToNextBSCell ^ expected_ToNextBSCell) &&
                expected_TristatedPin === (expected_TristatedPin ^ TristatedPin ^ expected_TristatedPin)) begin
                $display("PASS");
                $display("  Outputs: ToNextBSCell=%b, TristatedPin=%b",
                         ToNextBSCell, TristatedPin);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ToNextBSCell=%b, TristatedPin=%b",
                         expected_ToNextBSCell, expected_TristatedPin);
                $display("  Got:      ToNextBSCell=%b, TristatedPin=%b",
                         ToNextBSCell, TristatedPin);
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
        $dumpvars(0,CaptureDR, FromCore, FromOutputEnable, FromPreviousBSCell, ShiftDR, TCK, UpdateDR, extest, ToNextBSCell, TristatedPin);
    end

endmodule
