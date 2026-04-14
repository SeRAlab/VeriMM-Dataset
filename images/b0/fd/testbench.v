`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALU_OUT;
    reg [2:0] Fwd;
    reg [31:0] ID_Q;
    reg [31:0] res_hi;
    reg [31:0] res_lo;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_OUT(ALU_OUT),
        .Fwd(Fwd),
        .ID_Q(ID_Q),
        .res_hi(res_hi),
        .res_lo(res_lo),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            ID_Q    = 32'h1111_1111;
            ALU_OUT = 32'hFFFF_FFFF;
            res_hi  = 32'hAAAA_AAAA;
            res_lo  = 32'h5555_5555;
            Fwd     = 3'b000;
            $display("Test %0d: Select ID_Q (Fwd=000)", test_num);
            #1;

            check_outputs(32'h1111_1111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            ID_Q    = 32'h1111_1111;
            ALU_OUT = 32'h2222_2222;
            res_hi  = 32'hAAAA_AAAA;
            res_lo  = 32'h5555_5555;
            Fwd     = 3'b001;
            $display("Test %0d: Select ALU_OUT (Fwd=001)", test_num);
            #1;

            check_outputs(32'h2222_2222);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            ID_Q    = 32'h1111_1111;
            ALU_OUT = 32'h2222_2222;
            res_hi  = 32'h3333_3333;
            res_lo  = 32'h5555_5555;
            Fwd     = 3'b100;
            $display("Test %0d: Select res_hi (Fwd=100)", test_num);
            #1;

            check_outputs(32'h3333_3333);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            ID_Q    = 32'h1111_1111;
            ALU_OUT = 32'h2222_2222;
            res_hi  = 32'h3333_3333;
            res_lo  = 32'h4444_4444;
            Fwd     = 3'b101;
            $display("Test %0d: Select res_lo (Fwd=101)", test_num);
            #1;

            check_outputs(32'h4444_4444);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            ID_Q    = 32'h0;
            ALU_OUT = 32'h0;
            res_hi  = 32'h0;
            res_lo  = 32'h0;
            Fwd     = 3'b000;
            $display("Test %0d: Boundary - All Zeros (Fwd=000)", test_num);
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            ID_Q    = 32'hFFFF_FFFF;
            ALU_OUT = 32'hFFFF_FFFF;
            res_hi  = 32'hFFFF_FFFF;
            res_lo  = 32'hFFFF_FFFF;
            Fwd     = 3'b101;
            $display("Test %0d: Boundary - All Ones (Fwd=101)", test_num);
            #1;

            check_outputs(32'hFFFF_FFFF);
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
