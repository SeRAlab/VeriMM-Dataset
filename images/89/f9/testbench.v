`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] Rs_IFID_i;
    reg [4:0] Rt_IDEX_i;
    reg [4:0] Rt_IFID_i;
    reg branch_i;
    reg clk;
    reg jmp_i;
    reg mem_read_IDEX_i;
    reg reset;
    reg topc_i;
    wire IFID_disenabler_o;
    wire PC_disenabler_o;
    wire control_zero_mux_o;
    wire flush_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Rs_IFID_i(Rs_IFID_i),
        .Rt_IDEX_i(Rt_IDEX_i),
        .Rt_IFID_i(Rt_IFID_i),
        .branch_i(branch_i),
        .clk(clk),
        .jmp_i(jmp_i),
        .mem_read_IDEX_i(mem_read_IDEX_i),
        .reset(reset),
        .topc_i(topc_i),
        .IFID_disenabler_o(IFID_disenabler_o),
        .PC_disenabler_o(PC_disenabler_o),
        .control_zero_mux_o(control_zero_mux_o),
        .flush_o(flush_o)
    );
    task initialize;

    begin
        Rs_IFID_i = 0;
        Rt_IDEX_i = 0;
        Rt_IFID_i = 0;
        branch_i = 0;
        jmp_i = 0;
        mem_read_IDEX_i = 0;
        reset = 1;
        topc_i = 0;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset/Normal Operation", test_num);
        initialize();
        @(posedge clk);
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Load-use Hazard (Rs)", test_num);
        initialize();
        mem_read_IDEX_i = 1;
        Rt_IDEX_i = 5'd10;
        Rs_IFID_i = 5'd10;
        Rt_IFID_i = 5'd12;
        @(posedge clk);
        #1;

        check_outputs(1, 1, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Load-use Hazard (Rt)", test_num);
        initialize();
        mem_read_IDEX_i = 1;
        Rt_IDEX_i = 5'd15;
        Rs_IFID_i = 5'd05;
        Rt_IFID_i = 5'd15;
        @(posedge clk);
        #1;

        check_outputs(1, 1, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Control Hazard (Branch)", test_num);
        initialize();
        branch_i = 1;
        @(posedge clk);
        #1;

        check_outputs(0, 0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Control Hazard (Jump)", test_num);
        initialize();
        jmp_i = 1;
        @(posedge clk);
        #1;

        check_outputs(0, 0, 0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Control Hazard (TopPC)", test_num);
        initialize();
        topc_i = 1;
        @(posedge clk);
        #1;

        check_outputs(0, 0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Reg Match without MemRead", test_num);
        initialize();
        mem_read_IDEX_i = 0;
        Rt_IDEX_i = 5'd20;
        Rs_IFID_i = 5'd20;
        @(posedge clk);
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Simultaneous Stall and Flush", test_num);
        initialize();
        mem_read_IDEX_i = 1;
        Rt_IDEX_i = 5'd2;
        Rs_IFID_i = 5'd2;
        branch_i = 1;
        @(posedge clk);
        #1;

        check_outputs(1, 1, 1, 1);
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
        input expected_IFID_disenabler_o;
        input expected_PC_disenabler_o;
        input expected_control_zero_mux_o;
        input expected_flush_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_IFID_disenabler_o === (expected_IFID_disenabler_o ^ IFID_disenabler_o ^ expected_IFID_disenabler_o) &&
                expected_PC_disenabler_o === (expected_PC_disenabler_o ^ PC_disenabler_o ^ expected_PC_disenabler_o) &&
                expected_control_zero_mux_o === (expected_control_zero_mux_o ^ control_zero_mux_o ^ expected_control_zero_mux_o) &&
                expected_flush_o === (expected_flush_o ^ flush_o ^ expected_flush_o)) begin
                $display("PASS");
                $display("  Outputs: IFID_disenabler_o=%b, PC_disenabler_o=%b, control_zero_mux_o=%b, flush_o=%b",
                         IFID_disenabler_o, PC_disenabler_o, control_zero_mux_o, flush_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IFID_disenabler_o=%b, PC_disenabler_o=%b, control_zero_mux_o=%b, flush_o=%b",
                         expected_IFID_disenabler_o, expected_PC_disenabler_o, expected_control_zero_mux_o, expected_flush_o);
                $display("  Got:      IFID_disenabler_o=%b, PC_disenabler_o=%b, control_zero_mux_o=%b, flush_o=%b",
                         IFID_disenabler_o, PC_disenabler_o, control_zero_mux_o, flush_o);
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
