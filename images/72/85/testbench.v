`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Ao;
    reg [7:0] Dia;
    reg [7:0] Hor_RT;
    reg [7:0] Mes;
    reg [7:0] Min_RT;
    reg [7:0] Seg_RT;
    reg [3:0] Selector;
    wire [7:0] Dato_Reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ao(Ao),
        .Dia(Dia),
        .Hor_RT(Hor_RT),
        .Mes(Mes),
        .Min_RT(Min_RT),
        .Seg_RT(Seg_RT),
        .Selector(Selector),
        .Dato_Reg(Dato_Reg)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select Seg_RT (Selector = 0)", test_num);
            Seg_RT = 8'h59; Min_RT = 8'h45; Hor_RT = 8'h12;
            Dia = 8'h31; Mes = 8'h12; Ao = 8'h24;
            Selector = 4'd0;
            #1;

            check_outputs(8'h59);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select Min_RT (Selector = 1)", test_num);
            Seg_RT = 8'h59; Min_RT = 8'h45; Hor_RT = 8'h12;
            Dia = 8'h31; Mes = 8'h12; Ao = 8'h24;
            Selector = 4'd1;
            #1;

            check_outputs(8'h45);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select Hor_RT (Selector = 2)", test_num);
            Seg_RT = 8'h59; Min_RT = 8'h45; Hor_RT = 8'h12;
            Dia = 8'h31; Mes = 8'h12; Ao = 8'h24;
            Selector = 4'd2;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select Dia (Selector = 3)", test_num);
            Seg_RT = 8'h59; Min_RT = 8'h45; Hor_RT = 8'h12;
            Dia = 8'h31; Mes = 8'h12; Ao = 8'h24;
            Selector = 4'd3;
            #1;

            check_outputs(8'h31);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Select Mes (Selector = 4)", test_num);
            Seg_RT = 8'h59; Min_RT = 8'h45; Hor_RT = 8'h12;
            Dia = 8'h31; Mes = 8'h12; Ao = 8'h24;
            Selector = 4'd4;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Select Ao (Selector = 5)", test_num);
            Seg_RT = 8'h59; Min_RT = 8'h45; Hor_RT = 8'h12;
            Dia = 8'h31; Mes = 8'h12; Ao = 8'h24;
            Selector = 4'd5;
            #1;

            check_outputs(8'h24);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Invalid Selector (Selector = 6) -> Default zero", test_num);
            Seg_RT = 8'hAA; Min_RT = 8'hBB; Hor_RT = 8'hCC;
            Dia = 8'hDD; Mes = 8'hEE; Ao = 8'hFF;
            Selector = 4'd6;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Invalid Selector (Selector = 15) -> Default zero", test_num);
            Seg_RT = 8'hAA; Min_RT = 8'hBB; Hor_RT = 8'hCC;
            Dia = 8'hDD; Mes = 8'hEE; Ao = 8'hFF;
            Selector = 4'd15;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_Dato_Reg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Dato_Reg === (expected_Dato_Reg ^ Dato_Reg ^ expected_Dato_Reg)) begin
                $display("PASS");
                $display("  Outputs: Dato_Reg=%h",
                         Dato_Reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dato_Reg=%h",
                         expected_Dato_Reg);
                $display("  Got:      Dato_Reg=%h",
                         Dato_Reg);
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
