`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in_data1;
    reg [15:0] in_data2;
    reg [15:0] in_data3;
    reg [15:0] in_data4;
    reg [1:0] sel;
    wire [15:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_data1(in_data1),
        .in_data2(in_data2),
        .in_data3(in_data3),
        .in_data4(in_data4),
        .sel(sel),
        .out_data(out_data)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Selecting in_data1 (sel=00)", test_num);
        in_data1 = 16'hAAAA;
        in_data2 = 16'hBBBB;
        in_data3 = 16'hCCCC;
        in_data4 = 16'hDDDD;
        sel = 2'b00;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Selecting in_data2 (sel=01)", test_num);
        in_data1 = 16'hAAAA;
        in_data2 = 16'hBBBB;
        in_data3 = 16'hCCCC;
        in_data4 = 16'hDDDD;
        sel = 2'b01;
        #1;

        check_outputs(16'hBBBB);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Selecting in_data3 (sel=10)", test_num);
        in_data1 = 16'hAAAA;
        in_data2 = 16'hBBBB;
        in_data3 = 16'hCCCC;
        in_data4 = 16'hDDDD;
        sel = 2'b10;
        #1;

        check_outputs(16'hCCCC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Selecting in_data4 (sel=11)", test_num);
        in_data1 = 16'hAAAA;
        in_data2 = 16'hBBBB;
        in_data3 = 16'hCCCC;
        in_data4 = 16'hDDDD;
        sel = 2'b11;
        #1;

        check_outputs(16'hDDDD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Check zero value input", test_num);
        in_data1 = 16'h0000;
        in_data2 = 16'hFFFF;
        in_data3 = 16'h1234;
        in_data4 = 16'h5678;
        sel = 2'b00;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Check all-ones value input", test_num);
        in_data1 = 16'h0000;
        in_data2 = 16'hFFFF;
        in_data3 = 16'h1234;
        in_data4 = 16'h5678;
        sel = 2'b01;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Invalid selection (sel=2'bxx)", test_num);
        in_data1 = 16'h1111;
        in_data2 = 16'h2222;
        in_data3 = 16'h3333;
        in_data4 = 16'h4444;
        sel = 2'bxx;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_out_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
