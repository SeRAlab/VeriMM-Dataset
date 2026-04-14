`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg RegDst;
    reg [4:0] rd;
    reg [4:0] rt;
    wire [4:0] DstReg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RegDst(RegDst),
        .rd(rd),
        .rt(rt),
        .DstReg(DstReg)
    );
    task testcase001;

        begin
            test_num = 1;
            rt = 5'd10;
            rd = 5'd20;
            RegDst = 0;
            $display("Test %0d: Select rt (RegDst=0)", test_num);
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            rt = 5'd10;
            rd = 5'd20;
            RegDst = 1;
            $display("Test %0d: Select rd (RegDst=1)", test_num);
            #1;

            check_outputs(5'd20);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            rt = 5'b11111;
            rd = 5'b00000;
            RegDst = 0;
            $display("Test %0d: Select rt (All ones, RegDst=0)", test_num);
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            rt = 5'b11111;
            rd = 5'b00000;
            RegDst = 1;
            $display("Test %0d: Select rd (All zeros, RegDst=1)", test_num);
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            rt = 5'h15;
            rd = 5'h0A;
            RegDst = 0;
            $display("Test %0d: Alternating bits, select rt", test_num);
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            rt = 5'h15;
            rd = 5'h0A;
            RegDst = 1;
            $display("Test %0d: Alternating bits, select rd", test_num);
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            rt = 5'd31;
            rd = 5'd16;
            RegDst = 1;
            $display("Test %0d: Max value selection rd", test_num);
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            rt = 5'd31;
            rd = 5'd16;
            RegDst = 0;
            $display("Test %0d: Max value selection rt", test_num);
            #1;

            check_outputs(5'd31);
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
        input [4:0] expected_DstReg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DstReg === (expected_DstReg ^ DstReg ^ expected_DstReg)) begin
                $display("PASS");
                $display("  Outputs: DstReg=%h",
                         DstReg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DstReg=%h",
                         expected_DstReg);
                $display("  Got:      DstReg=%h",
                         DstReg);
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
