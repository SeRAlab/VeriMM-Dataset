`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] instruction;
    wire [5:0] funct;
    wire [15:0] imm;
    wire [25:0] jadr;
    wire [5:0] op;
    wire [4:0] rd;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] sa;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instruction(instruction),
        .funct(funct),
        .imm(imm),
        .jadr(jadr),
        .op(op),
        .rd(rd),
        .rs(rs),
        .rt(rt),
        .sa(sa)
    );
    task testcase001;

        begin
            test_num = 1;
            instruction = 32'h00430820;
            #1;

            check_outputs(6'h20, 16'h0820, 26'h0430820, 6'h00, 5'h01, 5'h02, 5'h03, 5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            instruction = 32'h20411234;

            #1;


            check_outputs(6'h34, 16'h1234, 26'h0411234, 6'h08, 5'h12, 5'h02, 5'h01, 5'h08);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            instruction = 32'h09234567;

            #1;


            check_outputs(6'h27, 16'h4567, 26'h1234567, 6'h02, 5'h08, 5'h09, 5'h03, 5'h15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            instruction = 32'h00000000;
            #1;

            check_outputs(6'h00, 16'h0000, 26'h0000000, 6'h00, 5'h00, 5'h00, 5'h00, 5'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            instruction = 32'hFFFFFFFF;
            #1;

            check_outputs(6'h3F, 16'hFFFF, 26'h3FFFFFF, 6'h3F, 5'h1F, 5'h1F, 5'h1F, 5'h1F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            instruction = 32'hAAAAAAAA;

            #1;


            check_outputs(6'h2A, 16'hAAAA, 26'h2AAAAAA, 6'h2A, 5'h15, 5'h15, 5'h0A, 5'h0A);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            instruction = 32'h55555555;

            #1;


            check_outputs(6'h15, 16'h5555, 26'h1555555, 6'h15, 5'h0A, 5'h0A, 5'h15, 5'h15);
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
        input [5:0] expected_funct;
        input [15:0] expected_imm;
        input [25:0] expected_jadr;
        input [5:0] expected_op;
        input [4:0] expected_rd;
        input [4:0] expected_rs;
        input [4:0] expected_rt;
        input [4:0] expected_sa;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_funct === (expected_funct ^ funct ^ expected_funct) &&
                expected_imm === (expected_imm ^ imm ^ expected_imm) &&
                expected_jadr === (expected_jadr ^ jadr ^ expected_jadr) &&
                expected_op === (expected_op ^ op ^ expected_op) &&
                expected_rd === (expected_rd ^ rd ^ expected_rd) &&
                expected_rs === (expected_rs ^ rs ^ expected_rs) &&
                expected_rt === (expected_rt ^ rt ^ expected_rt) &&
                expected_sa === (expected_sa ^ sa ^ expected_sa)) begin
                $display("PASS");
                $display("  Outputs: funct=%h, imm=%h, jadr=%h, op=%h, rd=%h, rs=%h, rt=%h, sa=%h",
                         funct, imm, jadr, op, rd, rs, rt, sa);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: funct=%h, imm=%h, jadr=%h, op=%h, rd=%h, rs=%h, rt=%h, sa=%h",
                         expected_funct, expected_imm, expected_jadr, expected_op, expected_rd, expected_rs, expected_rt, expected_sa);
                $display("  Got:      funct=%h, imm=%h, jadr=%h, op=%h, rd=%h, rs=%h, rt=%h, sa=%h",
                         funct, imm, jadr, op, rd, rs, rt, sa);
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
