`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] EX_MEM;
    reg [31:0] MEM_WB;
    reg [31:0] Q;
    reg [2:0] S;
    reg [31:0] res_hi;
    reg [31:0] res_lo;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_MEM(EX_MEM),
        .MEM_WB(MEM_WB),
        .Q(Q),
        .S(S),
        .res_hi(res_hi),
        .res_lo(res_lo),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            Q      = 32'hAAAA_AAAA;
            EX_MEM = 32'h1111_1111;
            MEM_WB = 32'h2222_2222;
            res_hi = 32'h3333_3333;
            res_lo = 32'h4444_4444;
            S      = 3'b000;
            $display("Testcase %0d: Select Q (S=000)", test_num);
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            Q      = 32'hAAAA_AAAA;
            EX_MEM = 32'h5555_5555;
            MEM_WB = 32'h2222_2222;
            res_hi = 32'h3333_3333;
            res_lo = 32'h4444_4444;
            S      = 3'b001;
            $display("Testcase %0d: Select EX_MEM (S=001)", test_num);
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            Q      = 32'hAAAA_AAAA;
            EX_MEM = 32'h5555_5555;
            MEM_WB = 32'hF0F0_F0F0;
            res_hi = 32'h3333_3333;
            res_lo = 32'h4444_4444;
            S      = 3'b010;
            $display("Testcase %0d: Select MEM_WB (S=010)", test_num);
            #1;

            check_outputs(32'hF0F0_F0F0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            Q      = 32'hAAAA_AAAA;
            EX_MEM = 32'h5555_5555;
            MEM_WB = 32'hF0F0_F0F0;
            res_hi = 32'h0F0F_0F0F;
            res_lo = 32'h4444_4444;
            S      = 3'b100;
            $display("Testcase %0d: Select res_hi (S=100)", test_num);
            #1;

            check_outputs(32'h0F0F_0F0F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            Q      = 32'hAAAA_AAAA;
            EX_MEM = 32'h5555_5555;
            MEM_WB = 32'hF0F0_F0F0;
            res_hi = 32'h0F0F_0F0F;
            res_lo = 32'hC0DE_C0DE;
            S      = 3'b101;
            $display("Testcase %0d: Select res_lo (S=101)", test_num);
            #1;

            check_outputs(32'hC0DE_C0DE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            Q      = 32'hFFFF_FFFF;
            EX_MEM = 32'hFFFF_FFFF;
            MEM_WB = 32'hFFFF_FFFF;
            res_hi = 32'hFFFF_FFFF;
            res_lo = 32'hFFFF_FFFF;
            S      = 3'b000;
            $display("Testcase %0d: All inputs High, Select Q (S=000)", test_num);
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            Q      = 32'h0000_0000;
            EX_MEM = 32'h0000_0000;
            MEM_WB = 32'h0000_0000;
            res_hi = 32'h0000_0000;
            res_lo = 32'h0000_0000;
            S      = 3'b101;
            $display("Testcase %0d: All inputs Low, Select res_lo (S=101)", test_num);
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            Q      = 32'h1234_5678;
            EX_MEM = 32'h9ABC_DEF0;
            MEM_WB = 32'hFFEE_DDCC;
            res_hi = 32'hBBAA_9988;
            res_lo = 32'h7766_5544;
            S      = 3'b010;
            $display("Testcase %0d: Alternating Bits, Select MEM_WB (S=010)", test_num);
            #1;

            check_outputs(32'hFFEE_DDCC);
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
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
