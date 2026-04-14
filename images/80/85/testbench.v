`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] Ctrl;
    reg [25:0] Imm26;
    wire [63:0] BusImm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ctrl(Ctrl),
        .Imm26(Imm26),
        .BusImm(BusImm)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        Ctrl = 3'b000;
        Imm26 = 26'h1FFC00;
        $display("Test %0d: Ctrl=0 (I-type), Input [21:10]=12'h7FF (Positive)", test_num);
        #1;

        check_outputs(64'h00000000000007FF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        Ctrl = 3'b000;
        Imm26 = 26'h200000;
        $display("Test %0d: Ctrl=0 (I-type), Input [21:10]=12'h800 (Negative)", test_num);
        #1;

        check_outputs(64'hFFFFFFFFFFFFF800);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        Ctrl = 3'b001;
        Imm26 = 26'h0FF000;
        $display("Test %0d: Ctrl=1 (D-type), Input [20:12]=9'h0FF (Positive)", test_num);
        #1;

        check_outputs(64'h00000000000000FF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        Ctrl = 3'b001;
        Imm26 = 26'h100000;
        $display("Test %0d: Ctrl=1 (D-type), Input [20:12]=9'h100 (Negative)", test_num);
        #1;

        check_outputs(64'hFFFFFFFFFFFFFF00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        Ctrl = 3'b010;
        Imm26 = 26'h07FFFFE0;
        $display("Test %0d: Ctrl=2 (B-cond), Input [23:5]=19'h3FFFF (Positive)", test_num);
        #1;

        check_outputs(64'h000000000003FFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        Ctrl = 3'b010;
        Imm26 = 26'h00800000;
        $display("Test %0d: Ctrl=2 (B-cond), Input [23:5]=19'h40000 (Negative)", test_num);
        #1;

        check_outputs(64'hFFFFFFFFFFFC0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        Ctrl = 3'b011;
        Imm26 = 26'h1FFFFFF;
        $display("Test %0d: Ctrl=3 (B/BL), Input [25:0]=26'h1FFFFFF (Positive)", test_num);
        #1;

        check_outputs(64'h0000000001FFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        Ctrl = 3'b011;
        Imm26 = 26'h2000000;
        $display("Test %0d: Ctrl=3 (B/BL), Input [25:0]=26'h2000000 (Negative)", test_num);
        #1;

        check_outputs(64'hFFFFFFFFFE000000);
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
        input [63:0] expected_BusImm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BusImm === (expected_BusImm ^ BusImm ^ expected_BusImm)) begin
                $display("PASS");
                $display("  Outputs: BusImm=%h",
                         BusImm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BusImm=%h",
                         expected_BusImm);
                $display("  Got:      BusImm=%h",
                         BusImm);
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
