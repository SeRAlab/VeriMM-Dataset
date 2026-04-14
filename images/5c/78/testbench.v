`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Hexs;
    reg [2:0] Scan;
    wire [7:0] Seg_map;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Hexs(Hexs),
        .Scan(Scan),
        .Seg_map(Seg_map)
    );
    task testcase001;

    begin
        test_num = 1;
        Hexs = 32'h11223344;
        Scan = 3'b000;
        $display("Testcase %0d: Testing Scan bits 00 (expecting Hexs[7:0])", test_num);
        #1;

        check_outputs(8'h44);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Hexs = 32'h11223344;
        Scan = 3'b001;
        $display("Testcase %0d: Testing Scan bits 01 (expecting Hexs[15:8])", test_num);
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Hexs = 32'h11223344;
        Scan = 3'b010;
        $display("Testcase %0d: Testing Scan bits 10 (expecting Hexs[23:16])", test_num);
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Hexs = 32'h11223344;
        Scan = 3'b011;
        $display("Testcase %0d: Testing Scan bits 11 (expecting Hexs[31:24])", test_num);
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Hexs = 32'hAABBCCDD;
        Scan = 3'b100;
        $display("Testcase %0d: Testing Scan bits 100 (expecting Hexs[7:0], ignoring MSB)", test_num);
        #1;

        check_outputs(8'hDD);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Hexs = 32'hAABBCCDD;
        Scan = 3'b110;
        $display("Testcase %0d: Testing Scan bits 110 (expecting Hexs[23:16], ignoring MSB)", test_num);
        #1;

        check_outputs(8'hBB);
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
        input [7:0] expected_Seg_map;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Seg_map === (expected_Seg_map ^ Seg_map ^ expected_Seg_map)) begin
                $display("PASS");
                $display("  Outputs: Seg_map=%h",
                         Seg_map);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Seg_map=%h",
                         expected_Seg_map);
                $display("  Got:      Seg_map=%h",
                         Seg_map);
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
