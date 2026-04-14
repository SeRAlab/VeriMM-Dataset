`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg beq;
    reg bne;
    reg [25:0] imm26;
    reg [31:0] increm;
    reg j;
    reg zero;
    wire [31:0] pc_out;
    wire pc_src;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .beq(beq),
        .bne(bne),
        .imm26(imm26),
        .increm(increm),
        .j(j),
        .zero(zero),
        .pc_out(pc_out),
        .pc_src(pc_src)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Normal PC Increment", test_num);
            beq = 0; bne = 0; j = 0; zero = 0;
            increm = 32'h00001000;
            imm26 = 26'h0000000;

            #1;


            check_outputs(32'h00001000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: BEQ Taken (Zero=1)", test_num);
            beq = 1; bne = 0; j = 0; zero = 1;
            increm = 32'h00001000;
            imm26 = 26'h0000005;

            #1;


            check_outputs(32'h00001014, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: BEQ Not Taken (Zero=0)", test_num);
            beq = 1; bne = 0; j = 0; zero = 0;
            increm = 32'h00001000;
            imm26 = 26'h0000005;

            #1;


            check_outputs(32'h00001000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: BNE Taken (Zero=0)", test_num);
            beq = 0; bne = 1; j = 0; zero = 0;
            increm = 32'h00002000;
            imm26 = 26'h0000002;

            #1;


            check_outputs(32'h00002008, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: BNE Not Taken (Zero=1)", test_num);
            beq = 0; bne = 1; j = 0; zero = 1;
            increm = 32'h00002000;
            imm26 = 26'h0000002;

            #1;


            check_outputs(32'h00002000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Jump Activated", test_num);
            beq = 0; bne = 0; j = 1; zero = 0;
            increm = 32'hF0000000;
            imm26 = 26'h0000001;

            #1;


            check_outputs(32'hF0000004, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Negative Branch Offset", test_num);
            beq = 1; bne = 0; j = 0; zero = 1;
            increm = 32'h00001004;
            imm26 = 26'h3FFFFFF;

            #1;


            check_outputs(32'h00001000, 1'b1);
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
        input [31:0] expected_pc_out;
        input expected_pc_src;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pc_out === (expected_pc_out ^ pc_out ^ expected_pc_out) &&
                expected_pc_src === (expected_pc_src ^ pc_src ^ expected_pc_src)) begin
                $display("PASS");
                $display("  Outputs: pc_out=%h, pc_src=%b",
                         pc_out, pc_src);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_out=%h, pc_src=%b",
                         expected_pc_out, expected_pc_src);
                $display("  Got:      pc_out=%h, pc_src=%b",
                         pc_out, pc_src);
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
