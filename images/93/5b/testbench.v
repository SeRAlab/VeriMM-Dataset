`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EXMEMMemRd;
    reg [4:0] EXMEMRt;
    reg IDEXMemRd;
    reg [4:0] IDEXRt;
    reg [4:0] IFIDRs;
    reg [4:0] IFIDRt;
    wire datahazard;
    wire flushIDEX;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXMEMMemRd(EXMEMMemRd),
        .EXMEMRt(EXMEMRt),
        .IDEXMemRd(IDEXMemRd),
        .IDEXRt(IDEXRt),
        .IFIDRs(IFIDRs),
        .IFIDRt(IFIDRt),
        .datahazard(datahazard),
        .flushIDEX(flushIDEX)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: No Hazard (Baseline)", test_num);
            IFIDRs = 5'd1; IFIDRt = 5'd2;
            IDEXRt = 5'd3; EXMEMRt = 5'd4;
            IDEXMemRd = 0; EXMEMMemRd = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: IDEX Hazard (Rs match)", test_num);
            IFIDRs = 5'd10; IFIDRt = 5'd11;
            IDEXRt = 5'd10; EXMEMRt = 5'd15;
            IDEXMemRd = 1;  EXMEMMemRd = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: IDEX Hazard (Rt match)", test_num);
            IFIDRs = 5'd10; IFIDRt = 5'd11;
            IDEXRt = 5'd11; EXMEMRt = 5'd15;
            IDEXMemRd = 1;  EXMEMMemRd = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: EXMEM Hazard (Rs match)", test_num);
            IFIDRs = 5'd20; IFIDRt = 5'd21;
            IDEXRt = 5'd25; EXMEMRt = 5'd20;
            IDEXMemRd = 0;  EXMEMMemRd = 1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: EXMEM Hazard (Rt match)", test_num);
            IFIDRs = 5'd20; IFIDRt = 5'd21;
            IDEXRt = 5'd25; EXMEMRt = 5'd21;
            IDEXMemRd = 0;  EXMEMMemRd = 1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Match with IDEXRt but not a Load", test_num);
            IFIDRs = 5'd5;  IFIDRt = 5'd6;
            IDEXRt = 5'd5;  EXMEMRt = 5'd10;
            IDEXMemRd = 0;  EXMEMMemRd = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Match with EXMEMRt but not a Load", test_num);
            IFIDRs = 5'd5;  IFIDRt = 5'd6;
            IDEXRt = 5'd12; EXMEMRt = 5'd6;
            IDEXMemRd = 0;  EXMEMMemRd = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Double Hazard", test_num);
            IFIDRs = 5'd5;  IFIDRt = 5'd6;
            IDEXRt = 5'd5;  EXMEMRt = 5'd6;
            IDEXMemRd = 1;  EXMEMMemRd = 1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Loads active but no register match", test_num);
            IFIDRs = 5'd1;  IFIDRt = 5'd2;
            IDEXRt = 5'd3;  EXMEMRt = 5'd4;
            IDEXMemRd = 1;  EXMEMMemRd = 1;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_datahazard;
        input expected_flushIDEX;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_datahazard === (expected_datahazard ^ datahazard ^ expected_datahazard) &&
                expected_flushIDEX === (expected_flushIDEX ^ flushIDEX ^ expected_flushIDEX)) begin
                $display("PASS");
                $display("  Outputs: datahazard=%b, flushIDEX=%b",
                         datahazard, flushIDEX);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: datahazard=%b, flushIDEX=%b",
                         expected_datahazard, expected_flushIDEX);
                $display("  Got:      datahazard=%b, flushIDEX=%b",
                         datahazard, flushIDEX);
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
