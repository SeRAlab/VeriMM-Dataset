`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire out_VGND;
    wire out_VNB;
    wire out_VPB;
    wire out_VPWR;

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
        .out_VGND(out_VGND),
        .out_VNB(out_VNB),
        .out_VPB(out_VPB),
        .out_VPWR(out_VPWR)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Normal Operation - All pins at standard supply levels", test_num);

        VPWR = 1'b1;
        VGND = 1'b0;
        VPB  = 1'b1;
        VNB  = 1'b0;



        #1;




        check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Power Down State - VPWR set to 0", test_num);
        VPWR = 1'b0;
        VGND = 1'b0;
        VPB  = 1'b1;
        VNB  = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Indeterminate VPWR (X) - Should default to LOW", test_num);

        VPWR = 1'bx;
        VGND = 1'b0;
        VPB  = 1'b1;
        VNB  = 1'b0;


        #1;



        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: High-Z VPWR (Z) - Should default to LOW", test_num);

        VPWR = 1'bz;
        VGND = 1'b0;
        VPB  = 1'b1;
        VNB  = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Signal Transparency Check - Varying VGND and Body Bias", test_num);

        VPWR = 1'b1;
        VGND = 1'b1;
        VPB  = 1'b0;
        VNB  = 1'b1;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 1'b1);
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
        input expected_out_VGND;
        input expected_out_VNB;
        input expected_out_VPB;
        input expected_out_VPWR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_VGND === (expected_out_VGND ^ out_VGND ^ expected_out_VGND) &&
                expected_out_VNB === (expected_out_VNB ^ out_VNB ^ expected_out_VNB) &&
                expected_out_VPB === (expected_out_VPB ^ out_VPB ^ expected_out_VPB) &&
                expected_out_VPWR === (expected_out_VPWR ^ out_VPWR ^ expected_out_VPWR)) begin
                $display("PASS");
                $display("  Outputs: out_VGND=%b, out_VNB=%b, out_VPB=%b, out_VPWR=%b",
                         out_VGND, out_VNB, out_VPB, out_VPWR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_VGND=%b, out_VNB=%b, out_VPB=%b, out_VPWR=%b",
                         expected_out_VGND, expected_out_VNB, expected_out_VPB, expected_out_VPWR);
                $display("  Got:      out_VGND=%b, out_VNB=%b, out_VPB=%b, out_VPWR=%b",
                         out_VGND, out_VNB, out_VPB, out_VPWR);
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
