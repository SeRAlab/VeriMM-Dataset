`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] PCSrc;
    reg ex_mem_MemRead;
    reg [4:0] ex_mem_write_addr;
    reg id_ex_MemRead;
    reg id_ex_RegWrite;
    reg [4:0] id_ex_write_addr;
    reg [4:0] if_id_rs_addr;
    reg [4:0] if_id_rt_addr;
    wire DataHazard;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PCSrc(PCSrc),
        .ex_mem_MemRead(ex_mem_MemRead),
        .ex_mem_write_addr(ex_mem_write_addr),
        .id_ex_MemRead(id_ex_MemRead),
        .id_ex_RegWrite(id_ex_RegWrite),
        .id_ex_write_addr(id_ex_write_addr),
        .if_id_rs_addr(if_id_rs_addr),
        .if_id_rt_addr(if_id_rt_addr),
        .DataHazard(DataHazard)
    );
    task reset_inputs;

    begin
        PCSrc = 3'b0;
        ex_mem_MemRead = 0;
        ex_mem_write_addr = 5'b0;
        id_ex_MemRead = 0;
        id_ex_RegWrite = 0;
        id_ex_write_addr = 5'b0;
        if_id_rs_addr = 5'b0;
        if_id_rt_addr = 5'b0;
        #1;
    end
        endtask

    task testcase001;

    begin
        reset_inputs();
        test_num = test_num + 1;
        $display("Test %0d: No Hazard - Independent Instructions", test_num);
        PCSrc = 3'b000;
        if_id_rs_addr = 5'd1;
        if_id_rt_addr = 5'd2;
        id_ex_MemRead = 1'b1;
        id_ex_write_addr = 5'd3;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_inputs();
        test_num = test_num + 1;
        $display("Test %0d: Load-Use Hazard on RS", test_num);
        PCSrc = 3'b000;
        if_id_rs_addr = 5'd5;
        if_id_rt_addr = 5'd6;
        id_ex_MemRead = 1'b1;
        id_ex_write_addr = 5'd5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_inputs();
        test_num = test_num + 1;
        $display("Test %0d: Load-Use Hazard on RT", test_num);
        PCSrc = 3'b000;
        if_id_rs_addr = 5'd5;
        if_id_rt_addr = 5'd6;
        id_ex_MemRead = 1'b1;
        id_ex_write_addr = 5'd6;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_inputs();
        test_num = test_num + 1;
        $display("Test %0d: Branch Hazard - Register in EX stage", test_num);
        PCSrc = 3'b001;
        if_id_rs_addr = 5'd10;
        id_ex_RegWrite = 1'b1;
        id_ex_write_addr = 5'd10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_inputs();
        test_num = test_num + 1;
        $display("Test %0d: Branch Hazard - Register in MEM stage Load", test_num);
        PCSrc = 3'b010;
        if_id_rt_addr = 5'd15;
        ex_mem_MemRead = 1'b1;
        ex_mem_write_addr = 5'd15;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_inputs();
        test_num = test_num + 1;
        $display("Test %0d: No Hazard on Register 0", test_num);
        PCSrc = 3'b000;
        if_id_rs_addr = 5'd0;
        id_ex_MemRead = 1'b1;
        id_ex_write_addr = 5'd0;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        reset_inputs();
        test_num = test_num + 1;
        $display("Test %0d: Multiple Hazard Conditions", test_num);
        PCSrc = 3'b001;
        if_id_rs_addr = 5'd4;
        if_id_rt_addr = 5'd8;
        id_ex_MemRead = 1'b1;
        id_ex_write_addr = 5'd4;
        ex_mem_MemRead = 1'b1;
        ex_mem_write_addr = 5'd8;
        #1;

        check_outputs(1'b1);
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
        input expected_DataHazard;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DataHazard === (expected_DataHazard ^ DataHazard ^ expected_DataHazard)) begin
                $display("PASS");
                $display("  Outputs: DataHazard=%b",
                         DataHazard);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DataHazard=%b",
                         expected_DataHazard);
                $display("  Got:      DataHazard=%b",
                         DataHazard);
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
