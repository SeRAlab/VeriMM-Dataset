`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Data_0;
    reg [31:0] Data_1;
    reg [31:0] Data_2;
    reg [31:0] Data_3;
    reg [1:0] selector;
    wire [31:0] Data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data_0(Data_0),
        .Data_1(Data_1),
        .Data_2(Data_2),
        .Data_3(Data_3),
        .selector(selector),
        .Data_out(Data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select 00 -> Expect Data_3", test_num);
            Data_0 = 32'h0000_0001;
            Data_1 = 32'h0000_0002;
            Data_2 = 32'h0000_0003;
            Data_3 = 32'hABCD_EF01;
            selector = 2'b00;
            #1;

            check_outputs(Data_3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select 01 -> Expect Data_2", test_num);
            Data_0 = 32'h1111_1111;
            Data_1 = 32'h2222_2222;
            Data_2 = 32'h3333_3333;
            Data_3 = 32'h4444_4444;
            selector = 2'b01;
            #1;

            check_outputs(Data_2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select 10 -> Expect Data_1", test_num);
            Data_0 = 32'hAAAA_AAAA;
            Data_1 = 32'hBBBB_BBBB;
            Data_2 = 32'hCCCC_CCCC;
            Data_3 = 32'hDDDD_DDDD;
            selector = 2'b10;
            #1;

            check_outputs(Data_1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select 11 -> Expect Data_0", test_num);
            Data_0 = 32'hFFFF_FFFF;
            Data_1 = 32'hEEEE_EEEE;
            Data_2 = 32'hDDDD_DDDD;
            Data_3 = 32'hCCCC_CCCC;
            selector = 2'b11;
            #1;

            check_outputs(Data_0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge Case - All inputs Zero", test_num);
            Data_0 = 32'h0;
            Data_1 = 32'h0;
            Data_2 = 32'h0;
            Data_3 = 32'h0;
            selector = 2'b00;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits and Selector Change", test_num);
            Data_0 = 32'h5555_5555;
            Data_1 = 32'hAAAA_AAAA;
            Data_2 = 32'h1234_5678;
            Data_3 = 32'h8765_4321;


            selector = 2'b01;
            #1;

            check_outputs(Data_2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max and Min Range Values", test_num);
            Data_0 = 32'hFFFF_FFFF;
            Data_1 = 32'h0000_0000;
            Data_2 = 32'h7FFF_FFFF;
            Data_3 = 32'h8000_0000;

            selector = 2'b10;
            #1;

            check_outputs(Data_1);
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
        input [31:0] expected_Data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Data_out === (expected_Data_out ^ Data_out ^ expected_Data_out)) begin
                $display("PASS");
                $display("  Outputs: Data_out=%h",
                         Data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data_out=%h",
                         expected_Data_out);
                $display("  Got:      Data_out=%h",
                         Data_out);
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
