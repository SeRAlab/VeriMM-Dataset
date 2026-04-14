`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] Bin;
    wire [31:0] Bout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Bin(Bin),
        .Bout(Bout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Bin = 0 (Minimum value)", test_num);
        Bin = 5'd0;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Bin = 1", test_num);
        Bin = 5'd1;
        #1;

        check_outputs(32'h00000003);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Bin = 3 (Example case)", test_num);
        Bin = 5'd3;
        #1;

        check_outputs(32'h0000000F);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Bin = 7", test_num);
        Bin = 5'd7;
        #1;

        check_outputs(32'h000000FF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Bin = 10", test_num);
        Bin = 5'd10;
        #1;

        check_outputs(32'h000007FF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Bin = 15", test_num);
        Bin = 5'd15;
        #1;

        check_outputs(32'h0000FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Bin = 16 (Middle + 1 boundary)", test_num);
        Bin = 5'd16;
        #1;

        check_outputs(32'h0001FFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Bin = 23", test_num);
        Bin = 5'd23;
        #1;

        check_outputs(32'h00FFFFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Bin = 30", test_num);
        Bin = 5'd30;
        #1;

        check_outputs(32'h7FFFFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Bin = 31 (Maximum value)", test_num);
        Bin = 5'd31;
        #1;

        check_outputs(32'hFFFFFFFF);
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
        testcase010();
        
        
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
        input [31:0] expected_Bout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Bout === (expected_Bout ^ Bout ^ expected_Bout)) begin
                $display("PASS");
                $display("  Outputs: Bout=%h",
                         Bout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Bout=%h",
                         expected_Bout);
                $display("  Got:      Bout=%h",
                         Bout);
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
