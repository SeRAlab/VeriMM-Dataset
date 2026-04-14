`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [46:0] Ecomp;
    wire [191:0] Euncomp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ecomp(Ecomp),
        .Euncomp(Euncomp)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Zeros (Null Input)", test_num);

        Ecomp = 47'h0;
        #10;

        #1;


        check_outputs(192'h0);
    end
    endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Ones (Maximum Magnitudes/Signs)", test_num);

        Ecomp = 47'h7FFFFFFFFFFF;
        #10;




        #1;





        check_outputs(192'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    end
    endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Alternating Bit Pattern (Checkerboard 1)", test_num);

        Ecomp = 47'h5555_5555_5555;
        #10;

        #1;


        check_outputs(192'h555555555555555555555555555555555555555555555555);
    end
    endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Alternating Bit Pattern (Checkerboard 2)", test_num);

        Ecomp = 47'h2AAA_AAAA_AAAA;
        #10;
        #1;

        check_outputs(192'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA);
    end
    endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Single Segment Activation (LSB Segment)", test_num);

        Ecomp = 47'h0000_0000_003F;
        #10;

        #1;


        check_outputs(192'h00000000000000000000000000000000000000000000003F);
    end
    endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: High-order Bit and Sign Indicator", test_num);

        Ecomp = 47'h4000_0000_0000;
        #10;



        #1;




        check_outputs(192'h800000000000000000000000000000000000000000000000);
    end
    endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Random Distribution Pattern", test_num);

        Ecomp = 47'h1234_5678_9ABC;
        #10;

        #1;


        check_outputs(192'h000012340000567800009ABC000012340000567800009ABC);
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
        input [191:0] expected_Euncomp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Euncomp === (expected_Euncomp ^ Euncomp ^ expected_Euncomp)) begin
                $display("PASS");
                $display("  Outputs: Euncomp=%h",
                         Euncomp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Euncomp=%h",
                         expected_Euncomp);
                $display("  Got:      Euncomp=%h",
                         Euncomp);
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
