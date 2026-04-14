`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] func;
    reg id_LW;
    reg [4:0] id_td;
    reg [5:0] op;
    reg [4:0] rs;
    reg [4:0] rt;
    wire stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .func(func),
        .id_LW(id_LW),
        .id_td(id_td),
        .op(op),
        .rs(rs),
        .rt(rt),
        .stall(stall)
    );
    task testcase001;

    begin
        test_num = 1;
        id_LW = 0;
        id_td = 5;
        rs = 5;
        rt = 6;
        op = 6'b000000;
        func = 6'b100000;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        id_LW = 1;
        id_td = 10;
        rs = 5;
        rt = 6;
        op = 6'b000000;
        func = 6'b100000;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        id_LW = 1;
        id_td = 5;
        rs = 5;
        rt = 6;
        op = 6'b000000;
        func = 6'b100000;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        id_LW = 1;
        id_td = 6;
        rs = 5;
        rt = 6;
        op = 6'b000000;
        func = 6'b100000;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        id_LW = 1;
        id_td = 8;
        rs = 8;
        rt = 9;
        op = 6'b100011;
        func = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        id_LW = 1;
        id_td = 9;
        rs = 8;
        rt = 9;
        op = 6'b100011;
        func = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        id_LW = 1;
        id_td = 4;
        rs = 2;
        rt = 4;
        op = 6'b101011;
        func = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        id_LW = 1;
        id_td = 12;
        rs = 12;
        rt = 13;
        op = 6'b001000;
        func = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        id_LW = 1;
        id_td = 13;
        rs = 12;
        rt = 13;
        op = 6'b001000;
        func = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        id_LW = 1;
        id_td = 0;
        rs = 0;
        rt = 0;
        op = 0;
        func = 0;
        #1;

        check_outputs(0);
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
        input expected_stall;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_stall === (expected_stall ^ stall ^ expected_stall)) begin
                $display("PASS");
                $display("  Outputs: stall=%b",
                         stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stall=%b",
                         expected_stall);
                $display("  Got:      stall=%b",
                         stall);
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
