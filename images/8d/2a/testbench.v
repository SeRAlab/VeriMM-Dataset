`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CaptureDR;
    reg FromPreviousBSCell;
    reg OutputControl;
    reg ShiftDR;
    reg TCK;
    reg UpdateDR;
    reg extest;
    wire ToNextBSCell;
    wire ToOutputEnable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CaptureDR(CaptureDR),
        .FromPreviousBSCell(FromPreviousBSCell),
        .OutputControl(OutputControl),
        .ShiftDR(ShiftDR),
        .TCK(TCK),
        .UpdateDR(UpdateDR),
        .extest(extest),
        .ToNextBSCell(ToNextBSCell),
        .ToOutputEnable(ToOutputEnable)
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
            OutputControl = 0;
            ShiftDR = 0;
            UpdateDR = 0;
            extest = 0;


            @(posedge TCK);
            #1;
            @(negedge TCK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: CaptureDR functionality", test_num);
            reset_dut();

            OutputControl = 1;
            CaptureDR = 1;
            ShiftDR = 0;

            @(posedge TCK);
            #2;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ShiftDR functionality", test_num);
            reset_dut();

            FromPreviousBSCell = 1;
            ShiftDR = 1;
            CaptureDR = 0;

            @(posedge TCK);
            #2;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: UpdateDR and extest=1", test_num);
            reset_dut();


            OutputControl = 1;
            CaptureDR = 1;
            ShiftDR = 0;
            @(posedge TCK);
            #2;


            UpdateDR = 1;
            extest = 1;
            @(negedge TCK);
            #2;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: UpdateDR with logic 0", test_num);
            reset_dut();


            FromPreviousBSCell = 1; ShiftDR = 1; @(posedge TCK); #2;


            FromPreviousBSCell = 0; ShiftDR = 1;
            @(posedge TCK);
            #2;


            UpdateDR = 1;
            extest = 1;
            @(negedge TCK);
            #2;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: extest=0 bypass mode", test_num);
            reset_dut();


            FromPreviousBSCell = 1; ShiftDR = 1; @(posedge TCK); #1;
            UpdateDR = 1; @(negedge TCK); #1;


            extest = 0;
            OutputControl = 0;
            #2;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data hold logic", test_num);
            reset_dut();


            FromPreviousBSCell = 1; ShiftDR = 1; @(posedge TCK); #2;


            ShiftDR = 0;
            CaptureDR = 0;
            FromPreviousBSCell = 0;
            @(posedge TCK);
            #2;


            #1;



            check_outputs(1'b1, 1'b0);
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
        input expected_ToOutputEnable;
        begin
            if (expected_ToNextBSCell === (expected_ToNextBSCell ^ ToNextBSCell ^ expected_ToNextBSCell) &&
                expected_ToOutputEnable === (expected_ToOutputEnable ^ ToOutputEnable ^ expected_ToOutputEnable)) begin
                $display("PASS");
                $display("  Outputs: ToNextBSCell=%b, ToOutputEnable=%b",
                         ToNextBSCell, ToOutputEnable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ToNextBSCell=%b, ToOutputEnable=%b",
                         expected_ToNextBSCell, expected_ToOutputEnable);
                $display("  Got:      ToNextBSCell=%b, ToOutputEnable=%b",
                         ToNextBSCell, ToOutputEnable);
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
        $dumpvars(0,CaptureDR, FromPreviousBSCell, OutputControl, ShiftDR, TCK, UpdateDR, extest, ToNextBSCell, ToOutputEnable);
    end

endmodule
