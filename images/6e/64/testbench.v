`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] ch_0;
    reg [7:0] ch_1;
    reg [7:0] ch_2;
    reg [7:0] ch_3;
    reg [1:0] select;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ch_0(ch_0),
        .ch_1(ch_1),
        .ch_2(ch_2),
        .ch_3(ch_3),
        .select(select),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        ch_0 = 8'h11;
        ch_1 = 22;
        ch_2 = 8'h33;
        ch_3 = 8'h44;
        select = 2'b00;
        $display("Testcase %0d: select=00 (Expect ch_3)", test_num);
        #1;

        check_outputs(8'h44);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ch_0 = 8'hAA;
        ch_1 = 8'hBB;
        ch_2 = 8'hCC;
        ch_3 = 8'hDD;
        select = 2'b01;
        $display("Testcase %0d: select=01 (Expect ch_2)", test_num);
        #1;

        check_outputs(8'hCC);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ch_0 = 8'h0F;
        ch_1 = 8'hF0;
        ch_2 = 8'h3C;
        ch_3 = 8'hC3;
        select = 2'b10;
        $display("Testcase %0d: select=10 (Expect ch_1)", test_num);
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ch_0 = 8'hA5;
        ch_1 = 8'h5A;
        ch_2 = 8'h77;
        ch_3 = 8'h88;
        select = 2'b11;
        $display("Testcase %0d: select=11 (Expect ch_0)", test_num);
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        ch_0 = 8'hFF;
        ch_1 = 8'hFF;
        ch_2 = 8'hFF;
        ch_3 = 8'hFF;
        select = 2'b01;
        $display("Testcase %0d: select=01 with identical inputs (Expect FF)", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        ch_0 = 8'h00;
        ch_1 = 8'h01;
        ch_2 = 8'h02;
        ch_3 = 8'h03;
        select = 2'b00;
        $display("Testcase %0d: select=00 with zero values (Expect 03)", test_num);
        #1;

        check_outputs(8'h03);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;

        ch_0 = 8'hDE;
        ch_1 = 8'hAD;
        ch_2 = 8'hBE;
        ch_3 = 8'hEF;
        select = 2'b11;
        $display("Testcase %0d: select=11 (Expect ch_0)", test_num);
        #1;

        check_outputs(8'hDE);
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
        input [7:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
