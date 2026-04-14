`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire HI;
    wire LO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST(RST),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .HI(HI),
        .LO(LO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            VPB = 0;
            VNB = 0;
            VPWR = 1;
            VGND = 0;
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking outputs after Reset", test_num);
            reset_dut();


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: VPB > VNB (1 > 0)", test_num);
            reset_dut();
            VPB = 1;
            VNB = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: VNB > VPB (1 > 0)", test_num);
            reset_dut();
            VPB = 0;
            VNB = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: VPB == VNB (1 == 1)", test_num);
            reset_dut();
            VPB = 1;
            VNB = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: VPB == VNB (0 == 0)", test_num);
            reset_dut();
            VPB = 0;
            VNB = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition VPB > VNB then VNB > VPB", test_num);
            reset_dut();

            VPB = 1; VNB = 0;
            @(posedge CLK);
            #1;

            VPB = 0; VNB = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: LO state to Equal state", test_num);
            reset_dut();

            VPB = 0; VNB = 1;
            @(posedge CLK);
            #1;

            VPB = 1; VNB = 1;
            @(posedge CLK);
            #1;
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
        input expected_HI;
        input expected_LO;
        begin
            if (expected_HI === (expected_HI ^ HI ^ expected_HI) &&
                expected_LO === (expected_LO ^ LO ^ expected_LO)) begin
                $display("PASS");
                $display("  Outputs: HI=%b, LO=%b",
                         HI, LO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HI=%b, LO=%b",
                         expected_HI, expected_LO);
                $display("  Got:      HI=%b, LO=%b",
                         HI, LO);
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
        $dumpvars(0,CLK, RST, VGND, VNB, VPB, VPWR, HI, LO);
    end

endmodule
