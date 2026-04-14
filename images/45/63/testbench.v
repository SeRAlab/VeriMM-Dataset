`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire VGND_OUT;
    wire VNB_OUT;
    wire VPB_OUT;
    wire VPWR_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .VGND_OUT(VGND_OUT),
        .VNB_OUT(VNB_OUT),
        .VPB_OUT(VPB_OUT),
        .VPWR_OUT(VPWR_OUT)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All inputs at baseline (VPWR=1, VGND=0, Control=0)", test_num);

        VGND = 0; VNB = 0; VPB = 0; VPWR = 1;


        #1;



        check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Set VPB high", test_num);
        VGND = 0; VNB = 0; VPB = 1; VPWR = 1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Set VNB high", test_num);
        VGND = 0; VNB = 1; VPB = 0; VPWR = 1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Both VPB and VNB high", test_num);
        VGND = 0; VNB = 1; VPB = 1; VPWR = 1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Power rails grounded", test_num);
        VGND = 0; VNB = 1; VPB = 1; VPWR = 0;


        #1;



        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Voltage level transition stress test (VPWR=0, VGND=1)", test_num);
        VGND = 1; VNB = 0; VPB = 1; VPWR = 0;



        #1;




        check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Full power state (All inputs 1)", test_num);
        VGND = 1; VNB = 1; VPB = 1; VPWR = 1;

        #1;


        check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Alternative baseline (VPWR=1.2, VGND=0.5 logic levels)", test_num);

        VGND = 0; VNB = 0; VPB = 0; VPWR = 1;
        #10;
        VGND = 0; VNB = 1; VPB = 0; VPWR = 1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
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
        input expected_VGND_OUT;
        input expected_VNB_OUT;
        input expected_VPB_OUT;
        input expected_VPWR_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_VGND_OUT === (expected_VGND_OUT ^ VGND_OUT ^ expected_VGND_OUT) &&
                expected_VNB_OUT === (expected_VNB_OUT ^ VNB_OUT ^ expected_VNB_OUT) &&
                expected_VPB_OUT === (expected_VPB_OUT ^ VPB_OUT ^ expected_VPB_OUT) &&
                expected_VPWR_OUT === (expected_VPWR_OUT ^ VPWR_OUT ^ expected_VPWR_OUT)) begin
                $display("PASS");
                $display("  Outputs: VGND_OUT=%b, VNB_OUT=%b, VPB_OUT=%b, VPWR_OUT=%b",
                         VGND_OUT, VNB_OUT, VPB_OUT, VPWR_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VGND_OUT=%b, VNB_OUT=%b, VPB_OUT=%b, VPWR_OUT=%b",
                         expected_VGND_OUT, expected_VNB_OUT, expected_VPB_OUT, expected_VPWR_OUT);
                $display("  Got:      VGND_OUT=%b, VNB_OUT=%b, VPB_OUT=%b, VPWR_OUT=%b",
                         VGND_OUT, VNB_OUT, VPB_OUT, VPWR_OUT);
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
