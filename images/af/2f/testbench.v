`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] rd_addr_EXMEM;
    reg [4:0] rd_addr_MEMWB;
    reg regwrite_EXMEM;
    reg regwrite_MEMWB;
    reg [4:0] rs_addr_IDEX;
    reg [4:0] rt_addr_IDEX;
    wire [1:0] forwardA;
    wire [1:0] forwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rd_addr_EXMEM(rd_addr_EXMEM),
        .rd_addr_MEMWB(rd_addr_MEMWB),
        .regwrite_EXMEM(regwrite_EXMEM),
        .regwrite_MEMWB(regwrite_MEMWB),
        .rs_addr_IDEX(rs_addr_IDEX),
        .rt_addr_IDEX(rt_addr_IDEX),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: No Hazard (different registers)", test_num);
        rs_addr_IDEX = 5'd1;
        rt_addr_IDEX = 5'd2;
        rd_addr_EXMEM = 5'd3;
        rd_addr_MEMWB = 5'd4;
        regwrite_EXMEM = 1'b1;
        regwrite_MEMWB = 1'b1;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: EX Hazard on rs", test_num);
        rs_addr_IDEX = 5'd10;
        rt_addr_IDEX = 5'd11;
        rd_addr_EXMEM = 5'd10;
        rd_addr_MEMWB = 5'd12;
        regwrite_EXMEM = 1'b1;
        regwrite_MEMWB = 1'b1;
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: EX Hazard on rt", test_num);
        rs_addr_IDEX = 5'd10;
        rt_addr_IDEX = 5'd11;
        rd_addr_EXMEM = 5'd11;
        rd_addr_MEMWB = 5'd12;
        regwrite_EXMEM = 1'b1;
        regwrite_MEMWB = 1'b1;
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: MEM Hazard on rs", test_num);
        rs_addr_IDEX = 5'd15;
        rt_addr_IDEX = 5'd16;
        rd_addr_EXMEM = 5'd20;
        rd_addr_MEMWB = 5'd15;
        regwrite_EXMEM = 1'b1;
        regwrite_MEMWB = 1'b1;
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: MEM Hazard on rt", test_num);
        rs_addr_IDEX = 5'd15;
        rt_addr_IDEX = 5'd16;
        rd_addr_EXMEM = 5'd20;
        rd_addr_MEMWB = 5'd16;
        regwrite_EXMEM = 1'b1;
        regwrite_MEMWB = 1'b1;
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Priority Check (EX over MEM)", test_num);
        rs_addr_IDEX = 5'd5;
        rt_addr_IDEX = 5'd5;
        rd_addr_EXMEM = 5'd5;
        rd_addr_MEMWB = 5'd5;
        regwrite_EXMEM = 1'b1;
        regwrite_MEMWB = 1'b1;
        #1;

        check_outputs(2'b10, 2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Register 0 Check", test_num);
        rs_addr_IDEX = 5'd0;
        rt_addr_IDEX = 5'd0;
        rd_addr_EXMEM = 5'd0;
        rd_addr_MEMWB = 5'd0;
        regwrite_EXMEM = 1'b1;
        regwrite_MEMWB = 1'b1;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: RegWrite Control Check", test_num);
        rs_addr_IDEX = 5'd10;
        rt_addr_IDEX = 5'd11;
        rd_addr_EXMEM = 5'd10;
        rd_addr_MEMWB = 5'd11;
        regwrite_EXMEM = 1'b0;
        regwrite_MEMWB = 1'b0;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %03d: Mixed Hazards (EX rs, MEM rt)", test_num);
        rs_addr_IDEX = 5'd21;
        rt_addr_IDEX = 5'd22;
        rd_addr_EXMEM = 5'd21;
        rd_addr_MEMWB = 5'd22;
        regwrite_EXMEM = 1'b1;
        regwrite_MEMWB = 1'b1;
        #1;

        check_outputs(2'b10, 2'b01);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %03d: Overlap with EX RegWrite disabled", test_num);
        rs_addr_IDEX = 5'd25;
        rt_addr_IDEX = 5'd25;
        rd_addr_EXMEM = 5'd25;
        rd_addr_MEMWB = 5'd25;
        regwrite_EXMEM = 1'b0;
        regwrite_MEMWB = 1'b1;
        #1;

        check_outputs(2'b01, 2'b01);
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
        input [1:0] expected_forwardA;
        input [1:0] expected_forwardB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forwardA === (expected_forwardA ^ forwardA ^ expected_forwardA) &&
                expected_forwardB === (expected_forwardB ^ forwardB ^ expected_forwardB)) begin
                $display("PASS");
                $display("  Outputs: forwardA=%h, forwardB=%h",
                         forwardA, forwardB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forwardA=%h, forwardB=%h",
                         expected_forwardA, expected_forwardB);
                $display("  Got:      forwardA=%h, forwardB=%h",
                         forwardA, forwardB);
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
