`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [4:0] ex_rs;
    reg [4:0] ex_rt;
    reg [4:0] mem_regAw;
    reg mem_regWrite;
    reg [4:0] wb_regAw;
    reg wb_regWrite;
    wire [1:0] forwardA;
    wire [1:0] forwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ex_rs(ex_rs),
        .ex_rt(ex_rt),
        .mem_regAw(mem_regAw),
        .mem_regWrite(mem_regWrite),
        .wb_regAw(wb_regAw),
        .wb_regWrite(wb_regWrite),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: No Hazards", test_num);
        ex_rs = 5'd1; ex_rt = 5'd2;
        mem_regAw = 5'd3; wb_regAw = 5'd4;
        mem_regWrite = 1'b1; wb_regWrite = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: MEM Hazard RS", test_num);
        ex_rs = 5'd10; ex_rt = 5'd11;
        mem_regAw = 5'd10; wb_regAw = 5'd12;
        mem_regWrite = 1'b1; wb_regWrite = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: MEM Hazard RT", test_num);
        ex_rs = 5'd10; ex_rt = 5'd11;
        mem_regAw = 5'd11; wb_regAw = 5'd12;
        mem_regWrite = 1'b1; wb_regWrite = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: WB Hazard RS", test_num);
        ex_rs = 5'd15; ex_rt = 5'd16;
        mem_regAw = 5'd17; wb_regAw = 5'd15;
        mem_regWrite = 1'b1; wb_regWrite = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: WB Hazard RT", test_num);
        ex_rs = 5'd15; ex_rt = 5'd16;
        mem_regAw = 5'd17; wb_regAw = 5'd16;
        mem_regWrite = 1'b1; wb_regWrite = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: MEM Hazard Both RS/RT", test_num);
        ex_rs = 5'd20; ex_rt = 5'd20;
        mem_regAw = 5'd20; wb_regAw = 5'd21;
        mem_regWrite = 1'b1; wb_regWrite = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(2'b10, 2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Mixed Hazard (RS:WB, RT:MEM)", test_num);
        ex_rs = 5'd25; ex_rt = 5'd26;
        mem_regAw = 5'd26; wb_regAw = 5'd25;
        mem_regWrite = 1'b1; wb_regWrite = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(2'b01, 2'b10);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Priority Check (MEM > WB)", test_num);
        ex_rs = 5'd5; ex_rt = 5'd5;
        mem_regAw = 5'd5; wb_regAw = 5'd5;
        mem_regWrite = 1'b1; wb_regWrite = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(2'b10, 2'b10);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: RegWrite Enable Check", test_num);
        ex_rs = 5'd8; ex_rt = 5'd9;
        mem_regAw = 5'd8; wb_regAw = 5'd9;
        mem_regWrite = 1'b0; wb_regWrite = 1'b0;
        @(posedge clk);
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Register 0 Check", test_num);
        ex_rs = 5'd0; ex_rt = 5'd0;
        mem_regAw = 5'd0; wb_regAw = 5'd0;
        mem_regWrite = 1'b1; wb_regWrite = 1'b1;
        @(posedge clk);
        #1;

        check_outputs(2'b00, 2'b00);
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
