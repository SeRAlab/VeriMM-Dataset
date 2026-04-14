`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] MuxCtrl;
    reg [31:0] exec_operand;
    reg [31:0] exec_operand_fast;
    reg [31:0] load_data;
    wire [33:0] MuxData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MuxCtrl(MuxCtrl),
        .exec_operand(exec_operand),
        .exec_operand_fast(exec_operand_fast),
        .load_data(load_data),
        .MuxData(MuxData)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Standard Execution (exec_operand)", test_num);
        MuxCtrl = 4'b0001;
        exec_operand = 32'hDEADBEEF;
        load_data    = 32'h11111111;
        exec_operand_fast = 32'h22222222;

        #1;


        check_outputs({2'b01, 32'hDEADBEEF});
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Load Data Path (load_data)", test_num);
        MuxCtrl = 4'b0010;
        exec_operand = 32'hAAAA_AAAA;
        load_data    = 32'hCAFE_BABE;
        exec_operand_fast = 32'h3333_3333;

        #1;


        check_outputs({2'b10, 32'hCAFE_BABE});
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Fast Execution (exec_operand_fast)", test_num);
        MuxCtrl = 4'b0011;
        exec_operand = 32'h4444_4444;
        load_data    = 32'h5555_5555;
        exec_operand_fast = 32'hFACE_FEED;

        #1;


        check_outputs({2'b11, 32'hFACE_FEED});
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Edge Case - All Inputs High", test_num);
        MuxCtrl = 4'b0010;
        exec_operand = 32'hFFFF_FFFF;
        load_data    = 32'hFFFF_FFFF;
        exec_operand_fast = 32'hFFFF_FFFF;

        #1;


        check_outputs({2'b10, 32'hFFFF_FFFF});
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Default Selection (MuxCtrl=0)", test_num);
        MuxCtrl = 4'b0000;
        exec_operand = 32'h1234_5678;
        load_data    = 32'h8765_4321;
        exec_operand_fast = 32'h0000_AAAA;

        #1;


        check_outputs({2'b00, 32'h0000_0000});
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
        input [33:0] expected_MuxData;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MuxData === (expected_MuxData ^ MuxData ^ expected_MuxData)) begin
                $display("PASS");
                $display("  Outputs: MuxData=%h",
                         MuxData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MuxData=%h",
                         expected_MuxData);
                $display("  Got:      MuxData=%h",
                         MuxData);
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
