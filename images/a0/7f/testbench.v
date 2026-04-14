`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Data_0;
    reg [31:0] Data_1;
    reg [31:0] Data_2;
    reg [31:0] Data_3;
    reg [31:0] Data_4;
    reg [31:0] Data_5;
    reg [31:0] Data_6;
    reg [2:0] selector;
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
        .Data_4(Data_4),
        .Data_5(Data_5),
        .Data_6(Data_6),
        .selector(selector),
        .Data_out(Data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select Data_0 (selector=000)", test_num);
        Data_0 = 32'hAAAA_0000;
        Data_1 = 32'hBBBB_1111;
        Data_2 = 32'hCCCC_2222;
        Data_3 = 32'hDDDD_3333;
        Data_4 = 32'hEEEE_4444;
        Data_5 = 32'hFFFF_5555;
        Data_6 = 32'h1234_6666;
        selector = 3'b000;
        #10;
        #1;

        check_outputs(32'hAAAA_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select Data_1 (selector=001)", test_num);
        selector = 3'b001;
        #10;
        #1;

        check_outputs(32'hBBBB_1111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Select Data_2 (selector=010)", test_num);
        selector = 3'b010;
        #10;
        #1;

        check_outputs(32'hCCCC_2222);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Select Data_3 (selector=011)", test_num);
        selector = 3'b011;
        #10;
        #1;

        check_outputs(32'hDDDD_3333);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Select Data_4 (selector=100)", test_num);
        selector = 3'b100;
        #10;
        #1;

        check_outputs(32'hEEEE_4444);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Select Data_5 (selector=101)", test_num);
        selector = 3'b101;
        #10;
        #1;

        check_outputs(32'hFFFF_5555);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Select Data_6 (selector=110)", test_num);
        selector = 3'b110;
        #10;
        #1;

        check_outputs(32'h1234_6666);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Change Data_0 value while selected", test_num);
        selector = 3'b000;
        Data_0 = 32'hDEAD_BEEF;
        #10;
        #1;

        check_outputs(32'hDEAD_BEEF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Switch from Data_6 to Data_3", test_num);
        Data_3 = 32'h55AA_55AA;
        Data_6 = 32'hAA55_AA55;
        selector = 3'b110; #5;
        selector = 3'b011;
        #10;
        #1;

        check_outputs(32'h55AA_55AA);
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
