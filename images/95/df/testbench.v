`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg ctrl_ex;
    reg ctrl_mem;
    reg [3:0] ex_rd;
    reg [3:0] mem_rd;
    wire [1:0] A_sel;
    wire [1:0] B_sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .ctrl_ex(ctrl_ex),
        .ctrl_mem(ctrl_mem),
        .ex_rd(ex_rd),
        .mem_rd(mem_rd),
        .A_sel(A_sel),
        .B_sel(B_sel)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No forwarding (ctrl signals low)", test_num);
            A = 4'h1; B = 4'h2;
            ex_rd = 4'h1; mem_rd = 4'h2;
            ctrl_ex = 0; ctrl_mem = 0;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EX forwarding for A", test_num);
            A = 4'h5; B = 4'hA;
            ex_rd = 4'h5; mem_rd = 4'h0;
            ctrl_ex = 1; ctrl_mem = 0;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MEM forwarding for B", test_num);
            A = 4'h3; B = 4'h7;
            ex_rd = 4'hF; mem_rd = 4'h7;
            ctrl_ex = 1; ctrl_mem = 1;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EX forwarding for both A and B", test_num);
            A = 4'hC; B = 4'hC;
            ex_rd = 4'hC; mem_rd = 4'h0;
            ctrl_ex = 1; ctrl_mem = 0;
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority check - EX over MEM for A", test_num);
            A = 4'h8; B = 4'h0;
            ex_rd = 4'h8; mem_rd = 4'h8;
            ctrl_ex = 1; ctrl_mem = 1;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed forwarding (A:MEM, B:EX)", test_num);
            A = 4'h2; B = 4'h4;
            ex_rd = 4'h4; mem_rd = 4'h2;
            ctrl_ex = 1; ctrl_mem = 1;
            #1;

            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No match with active ctrl signals", test_num);
            A = 4'h1; B = 4'h2;
            ex_rd = 4'h3; mem_rd = 4'h4;
            ctrl_ex = 1; ctrl_mem = 1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Forwarding address 0", test_num);
            A = 4'h0; B = 4'hF;
            ex_rd = 4'h0; mem_rd = 4'hF;
            ctrl_ex = 1; ctrl_mem = 1;
            #1;

            check_outputs(2'b01, 2'b10);
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
        input [1:0] expected_A_sel;
        input [1:0] expected_B_sel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_sel === (expected_A_sel ^ A_sel ^ expected_A_sel) &&
                expected_B_sel === (expected_B_sel ^ B_sel ^ expected_B_sel)) begin
                $display("PASS");
                $display("  Outputs: A_sel=%h, B_sel=%h",
                         A_sel, B_sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_sel=%h, B_sel=%h",
                         expected_A_sel, expected_B_sel);
                $display("  Got:      A_sel=%h, B_sel=%h",
                         A_sel, B_sel);
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
