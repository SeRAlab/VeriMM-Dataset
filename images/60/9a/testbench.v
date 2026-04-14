`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ins_i;
    wire [4:0] rd_o;
    wire [4:0] rs_o;
    wire [4:0] rt_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ins_i(ins_i),
        .rd_o(rd_o),
        .rs_o(rs_o),
        .rt_o(rt_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            ins_i = 32'h0000_0000;
            #1;

            check_outputs(5'h00, 5'h00, 5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            ins_i = 32'hFFFF_FFFF;

            #1;


            check_outputs(5'h1F, 5'h1F, 5'h1F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Field values rs=1, rt=2, rd=3", test_num);


            ins_i = (5'd1 << 21) | (5'd2 << 16) | (5'd3 << 11);
            #1;

            check_outputs(5'h03, 5'h01, 5'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify bits outside fields are ignored", test_num);

            ins_i = 32'hFC00_07FF;
            #1;

            check_outputs(5'h00, 5'h00, 5'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MIPS instruction 'add $t0, $s1, $s2'", test_num);


            ins_i = 32'h02324020;
            #1;

            check_outputs(5'd8, 5'd17, 5'd18);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bit patterns", test_num);

            ins_i = (5'b10101 << 21) | (5'b01010 << 16) | (5'b11001 << 11);
            #1;

            check_outputs(5'h19, 5'h15, 5'h0A);
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
        input [4:0] expected_rd_o;
        input [4:0] expected_rs_o;
        input [4:0] expected_rt_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rd_o === (expected_rd_o ^ rd_o ^ expected_rd_o) &&
                expected_rs_o === (expected_rs_o ^ rs_o ^ expected_rs_o) &&
                expected_rt_o === (expected_rt_o ^ rt_o ^ expected_rt_o)) begin
                $display("PASS");
                $display("  Outputs: rd_o=%h, rs_o=%h, rt_o=%h",
                         rd_o, rs_o, rt_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_o=%h, rs_o=%h, rt_o=%h",
                         expected_rd_o, expected_rs_o, expected_rt_o);
                $display("  Got:      rd_o=%h, rs_o=%h, rt_o=%h",
                         rd_o, rs_o, rt_o);
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
