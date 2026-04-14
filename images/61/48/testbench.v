`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [3:0] data4;
    reg [3:0] data5;
    reg [2:0] select;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .select(select),
        .out(out)
    );
    task init_inputs;

        begin
            data0 = 4'h0; data1 = 4'h0; data2 = 4'h0;
            data3 = 4'h0; data4 = 4'h0; data5 = 4'h0;
            select = 3'h0;
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        init_inputs();
        select = 3'd0;
        data0 = 4'b1111;
        $display("Test %0d: Select 0 (XOR path) with data0=4'b1111", test_num);
        #1;

        check_outputs(calculate_expected(select, data0, data1, data2, data3, data4, data5));
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        init_inputs();
        select = 3'd1;
        data1 = 4'b0000;
        $display("Test %0d: Select 1 (XOR path) with data1=4'b0000", test_num);
        #1;

        check_outputs(calculate_expected(select, data0, data1, data2, data3, data4, data5));
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        init_inputs();
        select = 3'd2;
        data2 = 4'b1010;
        $display("Test %0d: Select 2 (XOR path) with data2=4'b1010", test_num);
        #1;

        check_outputs(calculate_expected(select, data0, data1, data2, data3, data4, data5));
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        init_inputs();
        select = 3'd3;
        data3 = 4'b1111;
        $display("Test %0d: Select 3 (AND path) with data3=4'b1111", test_num);
        #1;

        check_outputs(calculate_expected(select, data0, data1, data2, data3, data4, data5));
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        init_inputs();
        select = 3'd4;
        data4 = 4'b1010;
        $display("Test %0d: Select 4 (AND path) with data4=4'b1010", test_num);
        #1;

        check_outputs(calculate_expected(select, data0, data1, data2, data3, data4, data5));
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        init_inputs();
        select = 3'd5;
        data5 = 4'b0101;
        $display("Test %0d: Select 5 (AND path) with data5=4'b0101", test_num);
        #1;

        check_outputs(calculate_expected(select, data0, data1, data2, data3, data4, data5));
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        init_inputs();

        select = 3'd0;
        data0 = 4'b1001;
        data1 = 4'b1111;
        $display("Test %0d: Mux isolation check (Select 0)", test_num);
        #1;

        check_outputs(calculate_expected(select, data0, data1, data2, data3, data4, data5));
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
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
