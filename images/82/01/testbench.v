`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg DIODE;
    reg [4:0] VGND;
    reg [4:0] VNB;
    reg [4:0] VPB;
    reg [4:0] VPWR;
    wire [4:0] VOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DIODE(DIODE),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .VOUT(VOUT)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: DIODE=0 (Output Disabled)", test_num);
        DIODE = 1'b0;
        VPB   = 5'd20;
        VNB   = 5'd5;
        VGND  = 5'd0;
        VPWR  = 5'd31;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: DIODE=1, VPB=15, VNB=10 (Positive Result)", test_num);
        DIODE = 1'b1;
        VPB   = 5'd15;
        VNB   = 5'd10;
        #1;

        check_outputs(5'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: DIODE=1, VPB=25, VNB=25 (Zero Result)", test_num);
        DIODE = 1'b1;
        VPB   = 5'd25;
        VNB   = 5'd25;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: DIODE=1, VPB=5, VNB=10 (Underflow/Wrap-around)", test_num);
        DIODE = 1'b1;
        VPB   = 5'd5;
        VNB   = 5'd10;
        #1;

        check_outputs(5'd27);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: DIODE=1, VPB=31, VNB=0 (Max Result)", test_num);
        DIODE = 1'b1;
        VPB   = 5'd31;
        VNB   = 5'd0;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: DIODE=1, VPB=0, VNB=31 (Wrap-around result 1)", test_num);
        DIODE = 1'b1;
        VPB   = 5'd0;
        VNB   = 5'd31;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: DIODE=0, high VPB/VNB (Verify output stays zero)", test_num);
        DIODE = 1'b0;
        VPB   = 5'd31;
        VNB   = 5'd31;
        #1;

        check_outputs(5'd0);
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
        input [4:0] expected_VOUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_VOUT === (expected_VOUT ^ VOUT ^ expected_VOUT)) begin
                $display("PASS");
                $display("  Outputs: VOUT=%h",
                         VOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VOUT=%h",
                         expected_VOUT);
                $display("  Got:      VOUT=%h",
                         VOUT);
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
