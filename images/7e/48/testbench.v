`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [30:0] A;
    reg [31:0] B;
    reg [4:0] Ctr;
    wire [31:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Ctr(Ctr),
        .R(R)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 31'h00000000;
        B = 32'hDEADBEEF;
        Ctr = 5'd0;
        #10;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 31'h7FFFFFFF;
        B = 32'h00000000;
        Ctr = 5'd1;

        #10;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 31'h12345678;
        B = 32'h80000000;
        Ctr = 5'd31;

        #10;
        #1;

        check_outputs(32'h2468ACF1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 31'h5555AAAA;
        B = 32'hAAAA5555;
        Ctr = 5'd16;

        #10;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 31'h12345678;
        B = 32'hABCDEF01;
        Ctr = 5'd8;

        #10;
        #1;

        check_outputs(32'h78ABCDEF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 31'h12345678;
        B = 32'hABCDEF01;
        Ctr = 5'd24;

        #10;
        #1;

        check_outputs(32'h345678AB);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 31'h7FFFFFFF;
        B = 32'hFFFFFFFF;
        Ctr = 5'd15;
        #10;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 31'h00000000;
        B = 32'hFFFFFFFF;
        Ctr = 5'd16;

        #10;
        #1;

        check_outputs(32'h0000FFFF);
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
        input [31:0] expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: R=%h",
                         R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R=%h",
                         expected_R);
                $display("  Got:      R=%h",
                         R);
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
