`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] ad;
    reg bd;
    reg [7:0] z;
    wire [7:0] az;
    wire bz;
    wire [7:0] d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ad(ad),
        .bd(bd),
        .z(z),
        .az(az),
        .bz(bz),
        .d(d)
    );
    task testcase001;

        begin
            test_num = 1;

            ad = 8'h00;
            bd = 1'b0;
            z  = 8'h00;

            #1;


            check_outputs(8'h00, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            ad = 8'hFF;
            bd = 1'b1;
            z  = 8'hFF;

            #1;


            check_outputs(8'hFF, 1'b1, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            ad = 8'hAA;
            bd = 1'b0;
            z  = 8'h55;

            #1;


            check_outputs(8'h55, 1'b0, 8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;

            ad = 8'h55;
            bd = 1'b1;
            z  = 8'hAA;

            #1;


            check_outputs(8'hAA, 1'b1, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            ad = 8'h12;
            bd = 1'b0;
            z  = 8'h34;

            #1;


            check_outputs(8'h34, 1'b0, 8'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            ad = 8'h80;
            bd = 1'b1;
            z  = 8'h01;

            #1;


            check_outputs(8'h01, 1'b1, 8'h80);
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
        input [7:0] expected_az;
        input expected_bz;
        input [7:0] expected_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_az === (expected_az ^ az ^ expected_az) &&
                expected_bz === (expected_bz ^ bz ^ expected_bz) &&
                expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: az=%h, bz=%b, d=%h",
                         az, bz, d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: az=%h, bz=%b, d=%h",
                         expected_az, expected_bz, expected_d);
                $display("  Got:      az=%h, bz=%b, d=%h",
                         az, bz, d);
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
