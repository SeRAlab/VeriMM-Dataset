`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] sel;
    reg [31:0] x0;
    reg [31:0] x1;
    reg [31:0] x10;
    reg [31:0] x11;
    reg [31:0] x12;
    reg [31:0] x13;
    reg [31:0] x14;
    reg [31:0] x15;
    reg [31:0] x2;
    reg [31:0] x3;
    reg [31:0] x4;
    reg [31:0] x5;
    reg [31:0] x6;
    reg [31:0] x7;
    reg [31:0] x8;
    reg [31:0] x9;
    wire [31:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sel(sel),
        .x0(x0),
        .x1(x1),
        .x10(x10),
        .x11(x11),
        .x12(x12),
        .x13(x13),
        .x14(x14),
        .x15(x15),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .x5(x5),
        .x6(x6),
        .x7(x7),
        .x8(x8),
        .x9(x9),
        .o(o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select Input 0", test_num);
        x0 = 32'hDEADBEEF; x1 = 32'h0; x2 = 32'h0; x3 = 32'h0;
        x4 = 32'h0; x5 = 32'h0; x6 = 32'h0; x7 = 32'h0;
        x8 = 32'h0; x9 = 32'h0; x10 = 32'h0; x11 = 32'h0;
        x12 = 32'h0; x13 = 32'h0; x14 = 32'h0; x15 = 32'h0;
        sel = 4'd0;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select Input 15", test_num);
        x15 = 32'hCAFEBABE;
        sel = 4'd15;
        #1;

        check_outputs(32'hCAFEBABE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Select Input 7 (Mid-range)", test_num);
        x7 = 32'h12345678;
        sel = 4'd7;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Verify all inputs with pattern", test_num);
        x0=32'h0; x1=32'h1; x2=32'h2; x3=32'h3;
        x4=32'h4; x5=32'h5; x6=32'h6; x7=32'h7;
        x8=32'h8; x9=32'h9; x10=32'hA; x11=32'hB;
        x12=32'hC; x13=32'hD; x14=32'hE; x15=32'hF;

        sel = 4'd3;
        #1;

        check_outputs(32'h3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Change select to 10", test_num);
        sel = 4'd10;
        #1;

        check_outputs(32'hA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Dynamic Input Update while sel=5", test_num);
        sel = 4'd5;
        x5 = 32'hAAAA_5555;
        #1;

        check_outputs(32'hAAAA_5555);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Select Input 1", test_num);
        x1 = 32'hFFFF_FFFF;
        sel = 4'd1;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Select Input 13", test_num);
        x13 = 32'h8888_8888;
        sel = 4'd13;
        #1;

        check_outputs(32'h8888_8888);
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
        input [31:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
