`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] act_add;
    reg [7:0] fila0;
    reg [7:0] fila1;
    reg [7:0] fila2;
    reg [7:0] fila3;
    reg [7:0] fila4;
    reg [7:0] fila5;
    reg [7:0] fila6;
    reg [7:0] fila7;
    wire [7:0] max_in;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .act_add(act_add),
        .fila0(fila0),
        .fila1(fila1),
        .fila2(fila2),
        .fila3(fila3),
        .fila4(fila4),
        .fila5(fila5),
        .fila6(fila6),
        .fila7(fila7),
        .max_in(max_in)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select fila0", test_num);
        act_add = 3'd0;
        fila0 = 8'hA0; fila1 = 8'hA1; fila2 = 8'hA2; fila3 = 8'hA3;
        fila4 = 8'hA4; fila5 = 8'hA5; fila6 = 8'hA6; fila7 = 8'hA7;
        #1;

        check_outputs(8'hA0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select fila1", test_num);
        act_add = 3'd1;
        fila0 = 8'hB0; fila1 = 8'hB1; fila2 = 8'hB2; fila3 = 8'hB3;
        fila4 = 8'hB4; fila5 = 8'hB5; fila6 = 8'hB6; fila7 = 8'hB7;
        #1;

        check_outputs(8'hB1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select fila2", test_num);
        act_add = 3'd2;
        fila0 = 8'hC0; fila1 = 8'hC1; fila2 = 8'hC2; fila3 = 8'hC3;
        fila4 = 8'hC4; fila5 = 8'hC5; fila6 = 8'hC6; fila7 = 8'hC7;
        #1;

        check_outputs(8'hC2);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select fila3", test_num);
        act_add = 3'd3;
        fila0 = 8'hD0; fila1 = 8'hD1; fila2 = 8'hD2; fila3 = 8'hD3;
        fila4 = 8'hD4; fila5 = 8'hD5; fila6 = 8'hD6; fila7 = 8'hD7;
        #1;

        check_outputs(8'hD3);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select fila4", test_num);
        act_add = 3'd4;
        fila0 = 8'hE0; fila1 = 8'hE1; fila2 = 8'hE2; fila3 = 8'hE3;
        fila4 = 8'hE4; fila5 = 8'hE5; fila6 = 8'hE6; fila7 = 8'hE7;
        #1;

        check_outputs(8'hE4);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select fila5", test_num);
        act_add = 3'd5;
        fila0 = 8'hF0; fila1 = 8'hF1; fila2 = 8'hF2; fila3 = 8'hF3;
        fila4 = 8'hF4; fila5 = 8'hF5; fila6 = 8'hF6; fila7 = 8'hF7;
        #1;

        check_outputs(8'hF5);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select fila6", test_num);
        act_add = 3'd6;
        fila0 = 8'h10; fila1 = 8'h11; fila2 = 8'h12; fila3 = 8'h13;
        fila4 = 8'h14; fila5 = 8'h15; fila6 = 8'h16; fila7 = 8'h17;
        #1;

        check_outputs(8'h16);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select fila7", test_num);
        act_add = 3'd7;
        fila0 = 8'h70; fila1 = 8'h71; fila2 = 8'h72; fila3 = 8'h73;
        fila4 = 8'h74; fila5 = 8'h75; fila6 = 8'h76; fila7 = 8'h77;
        #1;

        check_outputs(8'h77);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Invalid address check (X)", test_num);
        act_add = 3'bxxx;
        fila0 = 8'hFF; fila1 = 8'hFF; fila2 = 8'hFF; fila3 = 8'hFF;
        fila4 = 8'hFF; fila5 = 8'hFF; fila6 = 8'hFF; fila7 = 8'hFF;

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
        testcase009();
        
        
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
        input [7:0] expected_max_in;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_max_in === (expected_max_in ^ max_in ^ expected_max_in)) begin
                $display("PASS");
                $display("  Outputs: max_in=%h",
                         max_in);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max_in=%h",
                         expected_max_in);
                $display("  Got:      max_in=%h",
                         max_in);
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
