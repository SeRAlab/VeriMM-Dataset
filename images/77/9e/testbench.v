`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] out1;
    reg [3:0] out2;
    reg [3:0] out3;
    reg [3:0] out4;
    reg [1:0] scan_ctl_sel;
    wire [3:0] ring_out;
    wire [3:0] scan_ctl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4),
        .scan_ctl_sel(scan_ctl_sel),
        .ring_out(ring_out),
        .scan_ctl(scan_ctl)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select 0", test_num);
            scan_ctl_sel = 2'b00;
            out1 = 4'h1; out2 = 4'h2; out3 = 4'h3; out4 = 4'h4;

            #1;


            check_outputs(4'h1, 4'b1110);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select 1", test_num);
            scan_ctl_sel = 2'b01;
            out1 = 4'h1; out2 = 4'h2; out3 = 4'h3; out4 = 4'h4;

            #1;


            check_outputs(4'h2, 4'b1101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select 2", test_num);
            scan_ctl_sel = 2'b10;
            out1 = 4'h1; out2 = 4'h2; out3 = 4'h3; out4 = 4'h4;

            #1;


            check_outputs(4'h3, 4'b1011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select 3", test_num);
            scan_ctl_sel = 2'b11;
            out1 = 4'h1; out2 = 4'h2; out3 = 4'h3; out4 = 4'h4;

            #1;


            check_outputs(4'h4, 4'b0111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select 0 with High Data", test_num);
            scan_ctl_sel = 2'b00;
            out1 = 4'hF; out2 = 4'hE; out3 = 4'hD; out4 = 4'hC;
            #1;

            check_outputs(4'hF, 4'b1110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rapid Select Change (2 -> 3)", test_num);
            out1 = 4'hA; out2 = 4'hB; out3 = 4'hC; out4 = 4'hD;
            scan_ctl_sel = 2'b10;
            #5;
            scan_ctl_sel = 2'b11;
            #1;

            check_outputs(4'hD, 4'b0111);
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
        input [3:0] expected_ring_out;
        input [3:0] expected_scan_ctl;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ring_out === (expected_ring_out ^ ring_out ^ expected_ring_out) &&
                expected_scan_ctl === (expected_scan_ctl ^ scan_ctl ^ expected_scan_ctl)) begin
                $display("PASS");
                $display("  Outputs: ring_out=%h, scan_ctl=%h",
                         ring_out, scan_ctl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ring_out=%h, scan_ctl=%h",
                         expected_ring_out, expected_scan_ctl);
                $display("  Got:      ring_out=%h, scan_ctl=%h",
                         ring_out, scan_ctl);
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
