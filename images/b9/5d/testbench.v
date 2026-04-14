`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ADD4;
    reg CMP_out;
    reg [31:0] NPC;
    reg [2:0] PC_sel;
    reg [31:0] jrPC;
    wire [31:0] nextPC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADD4(ADD4),
        .CMP_out(CMP_out),
        .NPC(NPC),
        .PC_sel(PC_sel),
        .jrPC(jrPC),
        .nextPC(nextPC)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: PC_sel=3 -> Selection: jrPC", test_num);
        ADD4 = 32'h1111_1111;
        NPC  = 32'h2222_2222;
        jrPC = 32'h3333_3333;
        CMP_out = 0;
        PC_sel = 3'd3;
        #1;

        check_outputs(32'h3333_3333);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: PC_sel=2 -> Selection: NPC", test_num);
        ADD4 = 32'h1111_1111;
        NPC  = 32'h2222_2222;
        jrPC = 32'h3333_3333;
        CMP_out = 0;
        PC_sel = 3'd2;
        #1;

        check_outputs(32'h2222_2222);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: PC_sel=1, CMP_out=1 -> Selection: NPC", test_num);
        ADD4 = 32'h1111_1111;
        NPC  = 32'h4444_4444;
        jrPC = 32'h3333_3333;
        CMP_out = 1'b1;
        PC_sel = 3'd1;
        #1;

        check_outputs(32'h4444_4444);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: PC_sel=1, CMP_out=0 -> Selection: ADD4", test_num);
        ADD4 = 32'h1111_1111;
        NPC  = 32'h4444_4444;
        jrPC = 32'h3333_3333;
        CMP_out = 1'b0;
        PC_sel = 3'd1;
        #1;

        check_outputs(32'h1111_1111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: PC_sel=0 -> Selection: ADD4", test_num);
        ADD4 = 32'hAAAA_5555;
        NPC  = 32'h2222_2222;
        jrPC = 32'h3333_3333;
        CMP_out = 1;
        PC_sel = 3'd0;
        #1;

        check_outputs(32'hAAAA_5555);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: PC_sel=4 (Undefined value) -> Selection: ADD4", test_num);
        ADD4 = 32'hFFFF_0000;
        NPC  = 32'h2222_2222;
        jrPC = 32'h3333_3333;
        CMP_out = 1;
        PC_sel = 3'd4;
        #1;

        check_outputs(32'hFFFF_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Max values check (PC_sel=3)", test_num);
        ADD4 = 32'h0;
        NPC  = 32'h0;
        jrPC = 32'hFFFF_FFFF;
        CMP_out = 1;
        PC_sel = 3'd3;
        #1;

        check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_nextPC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nextPC === (expected_nextPC ^ nextPC ^ expected_nextPC)) begin
                $display("PASS");
                $display("  Outputs: nextPC=%h",
                         nextPC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nextPC=%h",
                         expected_nextPC);
                $display("  Got:      nextPC=%h",
                         nextPC);
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
