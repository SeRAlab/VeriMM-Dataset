`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [2:0] decoding_op_dest;
    reg [2:0] decoding_op_src1;
    reg [2:0] decoding_op_src2;
    reg [2:0] ex_op_dest;
    reg [2:0] mem_op_dest;
    reg rst;
    reg [2:0] wb_op_dest;
    wire pipeline_stall_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .decoding_op_dest(decoding_op_dest),
        .decoding_op_src1(decoding_op_src1),
        .decoding_op_src2(decoding_op_src2),
        .ex_op_dest(ex_op_dest),
        .mem_op_dest(mem_op_dest),
        .rst(rst),
        .wb_op_dest(wb_op_dest),
        .pipeline_stall_n(pipeline_stall_n)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset condition", test_num);
        rst = 1;
        decoding_op_src1 = 3'b001;
        decoding_op_src2 = 3'b010;
        ex_op_dest       = 3'b001;
        mem_op_dest      = 3'b000;
        wb_op_dest       = 3'b000;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: No hazard (all registers different)", test_num);
        rst = 1; #10; rst = 0;
        decoding_op_src1 = 3'b001;
        decoding_op_src2 = 3'b010;
        ex_op_dest       = 3'b011;
        mem_op_dest      = 3'b100;
        wb_op_dest       = 3'b101;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Hazard src1 vs EX dest", test_num);
        rst = 1; #10; rst = 0;
        decoding_op_src1 = 3'b101;
        decoding_op_src2 = 3'b000;
        ex_op_dest       = 3'b101;
        mem_op_dest      = 3'b000;
        wb_op_dest       = 3'b000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Hazard src2 vs EX dest", test_num);
        rst = 1; #10; rst = 0;
        decoding_op_src1 = 3'b000;
        decoding_op_src2 = 3'b110;
        ex_op_dest       = 3'b110;
        mem_op_dest      = 3'b000;
        wb_op_dest       = 3'b000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Hazard src1 vs MEM dest", test_num);
        rst = 1; #10; rst = 0;
        decoding_op_src1 = 3'b011;
        decoding_op_src2 = 3'b111;
        ex_op_dest       = 3'b000;
        mem_op_dest      = 3'b011;
        wb_op_dest       = 3'b000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Hazard src2 vs MEM dest", test_num);
        rst = 1; #10; rst = 0;
        decoding_op_src1 = 3'b001;
        decoding_op_src2 = 3'b010;
        ex_op_dest       = 3'b000;
        mem_op_dest      = 3'b010;
        wb_op_dest       = 3'b000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Hazard src1 vs WB dest", test_num);
        rst = 1; #10; rst = 0;
        decoding_op_src1 = 3'b100;
        decoding_op_src2 = 3'b000;
        ex_op_dest       = 3'b000;
        mem_op_dest      = 3'b000;
        wb_op_dest       = 3'b100;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Hazard src2 vs WB dest", test_num);
        rst = 1; #10; rst = 0;
        decoding_op_src1 = 3'b000;
        decoding_op_src2 = 3'b111;
        ex_op_dest       = 3'b000;
        mem_op_dest      = 3'b000;
        wb_op_dest       = 3'b111;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Multiple hazards", test_num);
        rst = 1; #10; rst = 0;
        decoding_op_src1 = 3'b001;
        decoding_op_src2 = 3'b010;
        ex_op_dest       = 3'b001;
        mem_op_dest      = 3'b010;
        wb_op_dest       = 3'b001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Decoding dest matching others (no stall)", test_num);
        rst = 1; #10; rst = 0;
        decoding_op_src1 = 3'b111;
        decoding_op_src2 = 3'b110;
        decoding_op_dest = 3'b001;
        ex_op_dest       = 3'b001;
        mem_op_dest      = 3'b000;
        wb_op_dest       = 3'b000;
        @(posedge clk);
        #1;
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
        input expected_pipeline_stall_n;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pipeline_stall_n === (expected_pipeline_stall_n ^ pipeline_stall_n ^ expected_pipeline_stall_n)) begin
                $display("PASS");
                $display("  Outputs: pipeline_stall_n=%b",
                         pipeline_stall_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pipeline_stall_n=%b",
                         expected_pipeline_stall_n);
                $display("  Got:      pipeline_stall_n=%b",
                         pipeline_stall_n);
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
