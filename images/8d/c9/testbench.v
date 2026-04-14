`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ex_flush;
    reg ex_jump;
    reg ex_load;
    reg [4:0] ex_rd;
    reg id_flush;
    reg mem_flush;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg s_exception;
    wire pc_pause;
    wire [3:0] pipe_bubble;
    wire [3:0] pipe_pause;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ex_flush(ex_flush),
        .ex_jump(ex_jump),
        .ex_load(ex_load),
        .ex_rd(ex_rd),
        .id_flush(id_flush),
        .mem_flush(mem_flush),
        .rs1(rs1),
        .rs2(rs2),
        .s_exception(s_exception),
        .pc_pause(pc_pause),
        .pipe_bubble(pipe_bubble),
        .pipe_pause(pipe_pause)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Normal Execution", test_num);
            ex_jump = 0; ex_load = 0; id_flush = 0; ex_flush = 0; mem_flush = 0;
            s_exception = 0; ex_rd = 5'd10; rs1 = 5'd1; rs2 = 5'd2;

            #1;


            check_outputs(1'b0, 4'b0000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Hazard (rs1)", test_num);
            ex_jump = 0; ex_load = 1; id_flush = 0; ex_flush = 0; mem_flush = 0;
            s_exception = 0; ex_rd = 5'd5; rs1 = 5'd5; rs2 = 5'd10;

            #1;


            check_outputs(1'b1, 4'b0010, 4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Hazard (rs2)", test_num);
            ex_jump = 0; ex_load = 1; id_flush = 0; ex_flush = 0; mem_flush = 0;
            s_exception = 0; ex_rd = 5'd8; rs1 = 5'd1; rs2 = 5'd8;

            #1;


            check_outputs(1'b1, 4'b0010, 4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load to x0 (Should not stall)", test_num);
            ex_jump = 0; ex_load = 1; id_flush = 0; ex_flush = 0; mem_flush = 0;
            s_exception = 0; ex_rd = 5'd0; rs1 = 5'd0; rs2 = 5'd0;

            #1;


            check_outputs(1'b0, 4'b0000, 4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Jump instruction in EX", test_num);
            ex_jump = 1; ex_load = 0; id_flush = 0; ex_flush = 0; mem_flush = 0;
            s_exception = 0; ex_rd = 5'd0; rs1 = 5'd1; rs2 = 5'd2;

            #1;


            check_outputs(1'b0, 4'b0001, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: System Exception", test_num);
            ex_jump = 0; ex_load = 0; id_flush = 0; ex_flush = 0; mem_flush = 0;
            s_exception = 1; ex_rd = 5'd0; rs1 = 5'd0; rs2 = 5'd0;

            #1;


            check_outputs(1'b0, 4'b1111, 4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ID Stage Flush", test_num);
            ex_jump = 0; ex_load = 0; id_flush = 1; ex_flush = 0; mem_flush = 0;
            s_exception = 0; ex_rd = 5'd0; rs1 = 5'd1; rs2 = 5'd2;

            #1;


            check_outputs(1'b0, 4'b0010, 4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: EX Stage Flush", test_num);
            ex_jump = 0; ex_load = 0; id_flush = 0; ex_flush = 1; mem_flush = 0;
            s_exception = 0; ex_rd = 5'd0; rs1 = 5'd1; rs2 = 5'd2;

            #1;


            check_outputs(1'b0, 4'b0100, 4'b0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MEM Stage Flush", test_num);
            ex_jump = 0; ex_load = 0; id_flush = 0; ex_flush = 0; mem_flush = 1;
            s_exception = 0; ex_rd = 5'd0; rs1 = 5'd1; rs2 = 5'd2;

            #1;


            check_outputs(1'b0, 4'b1000, 4'b0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Combined Load Hazard and Jump", test_num);
            ex_jump = 1; ex_load = 1; id_flush = 0; ex_flush = 0; mem_flush = 0;
            s_exception = 0; ex_rd = 5'd5; rs1 = 5'd5; rs2 = 5'd10;

            #1;


            check_outputs(1'b1, 4'b0011, 4'b0001);
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
        input expected_pc_pause;
        input [3:0] expected_pipe_bubble;
        input [3:0] expected_pipe_pause;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pc_pause === (expected_pc_pause ^ pc_pause ^ expected_pc_pause) &&
                expected_pipe_bubble === (expected_pipe_bubble ^ pipe_bubble ^ expected_pipe_bubble) &&
                expected_pipe_pause === (expected_pipe_pause ^ pipe_pause ^ expected_pipe_pause)) begin
                $display("PASS");
                $display("  Outputs: pc_pause=%b, pipe_bubble=%h, pipe_pause=%h",
                         pc_pause, pipe_bubble, pipe_pause);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_pause=%b, pipe_bubble=%h, pipe_pause=%h",
                         expected_pc_pause, expected_pipe_bubble, expected_pipe_pause);
                $display("  Got:      pc_pause=%b, pipe_bubble=%h, pipe_pause=%h",
                         pc_pause, pipe_bubble, pipe_pause);
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
