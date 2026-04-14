`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] In_0;
    reg [15:0] In_1;
    reg [15:0] In_2;
    reg [15:0] In_3;
    reg [15:0] In_4;
    reg [15:0] In_5;
    reg [15:0] In_6;
    reg [15:0] In_7;
    reg [2:0] select;
    wire [15:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In_0(In_0),
        .In_1(In_1),
        .In_2(In_2),
        .In_3(In_3),
        .In_4(In_4),
        .In_5(In_5),
        .In_6(In_6),
        .In_7(In_7),
        .select(select),
        .Out(Out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select In_0", test_num);
        In_0 = 16'hAAAA; In_1 = 16'h0001; In_2 = 16'h0002; In_3 = 16'h0003;
        In_4 = 16'h0004; In_5 = 16'h0005; In_6 = 16'h0006; In_7 = 16'h0007;
        select = 3'b000;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select In_1", test_num);
        In_0 = 16'h0000; In_1 = 16'hBBBB; In_2 = 16'h0002; In_3 = 16'h0003;
        In_4 = 16'h0004; In_5 = 16'h0005; In_6 = 16'h0006; In_7 = 16'h0007;
        select = 3'b001;
        #1;

        check_outputs(16'hBBBB);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select In_2", test_num);
        In_0 = 16'h0000; In_1 = 16'h0001; In_2 = 16'hCCCC; In_3 = 16'h0003;
        In_4 = 16'h0004; In_5 = 16'h0005; In_6 = 16'h0006; In_7 = 16'h0007;
        select = 3'b010;
        #1;

        check_outputs(16'hCCCC);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select In_3", test_num);
        In_0 = 16'h0000; In_1 = 16'h0001; In_2 = 16'h0002; In_3 = 16'hDDDD;
        In_4 = 16'h0004; In_5 = 16'h0005; In_6 = 16'h0006; In_7 = 16'h0007;
        select = 3'b011;
        #1;

        check_outputs(16'hDDDD);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select In_4", test_num);
        In_0 = 16'h0000; In_1 = 16'h0001; In_2 = 16'h0002; In_3 = 16'h0003;
        In_4 = 16'hEEEE; In_5 = 16'h0005; In_6 = 16'h0006; In_7 = 16'h0007;
        select = 3'b100;
        #1;

        check_outputs(16'hEEEE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select In_5", test_num);
        In_0 = 16'h0000; In_1 = 16'h0001; In_2 = 16'h0002; In_3 = 16'h0003;
        In_4 = 16'h0004; In_5 = 16'hFFFF; In_6 = 16'h0006; In_7 = 16'h0007;
        select = 3'b101;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select In_6", test_num);
        In_0 = 16'h0000; In_1 = 16'h0001; In_2 = 16'h0002; In_3 = 16'h0003;
        In_4 = 16'h0004; In_5 = 16'h0005; In_6 = 16'h1234; In_7 = 16'h0007;
        select = 3'b110;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select In_7", test_num);
        In_0 = 16'h0000; In_1 = 16'h0001; In_2 = 16'h0002; In_3 = 16'h0003;
        In_4 = 16'h0004; In_5 = 16'h0005; In_6 = 16'h0006; In_7 = 16'h5678;
        select = 3'b111;
        #1;

        check_outputs(16'h5678);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary Values All F", test_num);
        In_0 = 16'hFFFF; In_1 = 16'hFFFF; In_2 = 16'hFFFF; In_3 = 16'hFFFF;
        In_4 = 16'hFFFF; In_5 = 16'hFFFF; In_6 = 16'hFFFF; In_7 = 16'hFFFF;
        select = 3'b101;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary Values All 0", test_num);
        In_0 = 16'h0000; In_1 = 16'h0000; In_2 = 16'h0000; In_3 = 16'h0000;
        In_4 = 16'h0000; In_5 = 16'h0000; In_6 = 16'h0000; In_7 = 16'h0000;
        select = 3'b010;
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
        input [15:0] expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
