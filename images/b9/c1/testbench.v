`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] B_In;
    reg [31:0] C;
    reg LD_MUL;
    reg MUL_HiLo;
    reg U;
    wire [31:0] B_Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B_In(B_In),
        .C(C),
        .LD_MUL(LD_MUL),
        .MUL_HiLo(MUL_HiLo),
        .U(U),
        .B_Out(B_Out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Unsigned 10 * 5, MUL_HiLo=0 (Lo)", test_num);
            B_In = 32'd10;
            C = 32'd5;
            U = 1'b1;
            LD_MUL = 1'b1;
            MUL_HiLo = 1'b0;
            #1;

            check_outputs(32'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Unsigned 10 * 5, MUL_HiLo=1 (Hi)", test_num);
            B_In = 32'd10;
            C = 32'd5;
            U = 1'b1;
            LD_MUL = 1'b1;
            MUL_HiLo = 1'b1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Unsigned 0xFFFFFFFF * 2, MUL_HiLo=0 (Lo)", test_num);
            B_In = 32'hFFFFFFFF;
            C = 32'd2;
            U = 1'b1;
            LD_MUL = 1'b1;
            MUL_HiLo = 1'b0;

            #1;


            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Unsigned 0xFFFFFFFF * 2, MUL_HiLo=1 (Hi)", test_num);
            B_In = 32'hFFFFFFFF;
            C = 32'd2;
            U = 1'b1;
            LD_MUL = 1'b1;
            MUL_HiLo = 1'b1;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed 5 * -1, MUL_HiLo=0 (Lo)", test_num);
            B_In = 32'd5;
            C = 32'hFFFFFFFF;
            U = 1'b0;
            LD_MUL = 1'b1;
            MUL_HiLo = 1'b0;

            #1;


            check_outputs(32'hFFFFFFFB);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed 5 * -1, MUL_HiLo=1 (Hi)", test_num);
            B_In = 32'd5;
            C = 32'hFFFFFFFF;
            U = 1'b0;
            LD_MUL = 1'b1;
            MUL_HiLo = 1'b1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed -2 * -3, MUL_HiLo=0 (Lo)", test_num);
            B_In = 32'hFFFFFFFE;
            C = 32'hFFFFFFFD;
            U = 1'b0;
            LD_MUL = 1'b1;
            MUL_HiLo = 1'b0;

            #1;


            check_outputs(32'd6);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed -2 * -3, MUL_HiLo=1 (Hi)", test_num);
            B_In = 32'hFFFFFFFE;
            C = 32'hFFFFFFFD;
            U = 1'b0;
            LD_MUL = 1'b1;
            MUL_HiLo = 1'b1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Unsigned Max * Max, MUL_HiLo=0 (Lo)", test_num);
            B_In = 32'hFFFFFFFF;
            C = 32'hFFFFFFFF;
            U = 1'b1;
            LD_MUL = 1'b1;
            MUL_HiLo = 1'b0;

            #1;


            check_outputs(32'h00000001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Unsigned Max * Max, MUL_HiLo=1 (Hi)", test_num);
            B_In = 32'hFFFFFFFF;
            C = 32'hFFFFFFFF;
            U = 1'b1;
            LD_MUL = 1'b1;
            MUL_HiLo = 1'b1;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed 0x80000000 * 2, MUL_HiLo=1 (Hi)", test_num);
            B_In = 32'h80000000;
            C = 32'd2;
            U = 1'b0;
            LD_MUL = 1'b1;
            MUL_HiLo = 1'b1;

            #1;


            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: LD_MUL=0 (Disabled)", test_num);
            B_In = 32'd100;
            C = 32'd100;
            U = 1'b1;
            LD_MUL = 1'b0;
            MUL_HiLo = 1'b0;

            #1;


            check_outputs(32'h00000000);
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
        testcase011();
        testcase012();
        
        
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
        input [31:0] expected_B_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B_Out === (expected_B_Out ^ B_Out ^ expected_B_Out)) begin
                $display("PASS");
                $display("  Outputs: B_Out=%h",
                         B_Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B_Out=%h",
                         expected_B_Out);
                $display("  Got:      B_Out=%h",
                         B_Out);
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
