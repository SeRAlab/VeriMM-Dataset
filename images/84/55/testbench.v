`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] address_1;
    reg [15:0] address_2;
    reg [15:0] data_in_1;
    reg [15:0] data_in_2;
    reg enable_1;
    reg enable_2;
    reg wea_1;
    reg wea_2;
    wire [15:0] address;
    wire [15:0] data_in;
    wire enable;
    wire wea;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address_1(address_1),
        .address_2(address_2),
        .data_in_1(data_in_1),
        .data_in_2(data_in_2),
        .enable_1(enable_1),
        .enable_2(enable_2),
        .wea_1(wea_1),
        .wea_2(wea_2),
        .address(address),
        .data_in(data_in),
        .enable(enable),
        .wea(wea)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: All enables low", test_num);
        enable_1 = 0; wea_1 = 1; data_in_1 = 16'hAAAA; address_1 = 16'h1111;
        enable_2 = 0; wea_2 = 1; data_in_2 = 16'hBBBB; address_2 = 16'h2222;


        #1;



        check_outputs(16'h0000, 16'h0000, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Port 1 active (Write)", test_num);
        enable_1 = 1; wea_1 = 1; data_in_1 = 16'hC0DE; address_1 = 16'h1001;
        enable_2 = 0; wea_2 = 0; data_in_2 = 16'h0000; address_2 = 16'h0000;


        #1;



        check_outputs(16'h1001, 16'hC0DE, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Port 1 active (Read)", test_num);
        enable_1 = 1; wea_1 = 0; data_in_1 = 16'h0000; address_1 = 16'h5555;
        enable_2 = 0; wea_2 = 1; data_in_2 = 16'hFFFF; address_2 = 16'hAAAA;


        #1;



        check_outputs(16'h5555, 16'h0000, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Port 2 active (Write)", test_num);
        enable_1 = 0; wea_1 = 0; data_in_1 = 16'h0000; address_1 = 16'h0000;
        enable_2 = 1; wea_2 = 1; data_in_2 = 16'hBEEF; address_2 = 16'h2002;


        #1;



        check_outputs(16'h2002, 16'hBEEF, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Port 2 active (Read)", test_num);
        enable_1 = 0; wea_1 = 1; data_in_1 = 16'h1234; address_1 = 16'h4321;
        enable_2 = 1; wea_2 = 0; data_in_2 = 16'hDEAD; address_2 = 16'h8888;


        #1;



        check_outputs(16'h8888, 16'hDEAD, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Both ports active (Port 1 Priority)", test_num);
        enable_1 = 1; wea_1 = 1; data_in_1 = 16'hAAAA; address_1 = 16'h1111;
        enable_2 = 1; wea_2 = 0; data_in_2 = 16'hBBBB; address_2 = 16'h2222;


        #1;



        check_outputs(16'h1111, 16'hAAAA, 1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Rapid Toggle Test", test_num);
        enable_1 = 1; wea_1 = 1; data_in_1 = 16'h0001; address_1 = 16'h0001;
        #5;
        enable_1 = 0; enable_2 = 1; wea_2 = 1; data_in_2 = 16'h0002; address_2 = 16'h0002;


        #1;



        check_outputs(16'h0002, 16'h0002, 1'b1, 1'b1);
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
        input [15:0] expected_address;
        input [15:0] expected_data_in;
        input expected_enable;
        input expected_wea;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_address === (expected_address ^ address ^ expected_address) &&
                expected_data_in === (expected_data_in ^ data_in ^ expected_data_in) &&
                expected_enable === (expected_enable ^ enable ^ expected_enable) &&
                expected_wea === (expected_wea ^ wea ^ expected_wea)) begin
                $display("PASS");
                $display("  Outputs: address=%h, data_in=%h, enable=%b, wea=%b",
                         address, data_in, enable, wea);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address=%h, data_in=%h, enable=%b, wea=%b",
                         expected_address, expected_data_in, expected_enable, expected_wea);
                $display("  Got:      address=%h, data_in=%h, enable=%b, wea=%b",
                         address, data_in, enable, wea);
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
