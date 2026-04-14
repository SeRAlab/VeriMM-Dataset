`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ld;
    reg req_size;
    reg [7:0] sizez;
    reg vz;
    reg [7:0] z;
    wire [7:0] d;
    wire lz;
    wire [7:0] size;
    wire sizelz;
    wire vd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ld(ld),
        .req_size(req_size),
        .sizez(sizez),
        .vz(vz),
        .z(z),
        .d(d),
        .lz(lz),
        .size(size),
        .sizelz(sizelz),
        .vd(vd)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Data Transfer (z and vz)");
            ld = 0;
            req_size = 0;
            sizez = 8'h00;
            vz = 1;
            z = 8'hA5;
            #10;
            #1;

            check_outputs(8'hA5, 0, 8'h00, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Load Status (ld)");
            ld = 1;
            req_size = 0;
            sizez = 8'h00;
            vz = 0;
            z = 8'h00;
            #10;
            #1;

            check_outputs(8'h00, 1, 8'h00, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Size Request (sizez and req_size)");
            ld = 0;
            req_size = 1;
            sizez = 8'h42;
            vz = 0;
            z = 8'h00;
            #10;
            #1;

            check_outputs(8'h00, 0, 8'h42, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Concurrent Active Signals");
            ld = 1;
            req_size = 1;
            sizez = 8'hFF;
            vz = 1;
            z = 8'h5A;
            #10;
            #1;

            check_outputs(8'h5A, 1, 8'hFF, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: All Zero/Inactive");
            ld = 0;
            req_size = 0;
            sizez = 8'h00;
            vz = 0;
            z = 8'h00;
            #10;
            #1;

            check_outputs(8'h00, 0, 8'h00, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Data Boundary Values");
            ld = 0;
            req_size = 0;
            sizez = 8'h80;
            vz = 1;
            z = 8'h7F;
            #10;
            #1;

            check_outputs(8'h7F, 0, 8'h80, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Rapid Toggle Check");
            ld = 1;
            req_size = 0;
            sizez = 8'hAA;
            vz = 0;
            z = 8'h33;
            #5;

            ld = 0;
            req_size = 1;
            vz = 1;
            #5;
            #1;

            check_outputs(8'h33, 0, 8'hAA, 1, 1);
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
        input [7:0] expected_d;
        input expected_lz;
        input [7:0] expected_size;
        input expected_sizelz;
        input expected_vd;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d === (expected_d ^ d ^ expected_d) &&
                expected_lz === (expected_lz ^ lz ^ expected_lz) &&
                expected_size === (expected_size ^ size ^ expected_size) &&
                expected_sizelz === (expected_sizelz ^ sizelz ^ expected_sizelz) &&
                expected_vd === (expected_vd ^ vd ^ expected_vd)) begin
                $display("PASS");
                $display("  Outputs: d=%h, lz=%b, size=%h, sizelz=%b, vd=%b",
                         d, lz, size, sizelz, vd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d=%h, lz=%b, size=%h, sizelz=%b, vd=%b",
                         expected_d, expected_lz, expected_size, expected_sizelz, expected_vd);
                $display("  Got:      d=%h, lz=%b, size=%h, sizelz=%b, vd=%b",
                         d, lz, size, sizelz, vd);
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
