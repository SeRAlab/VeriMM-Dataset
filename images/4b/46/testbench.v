`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] ch_0;
    reg [7:0] ch_1;
    reg [7:0] ch_2;
    reg [7:0] ch_3;
    reg [7:0] ch_4;
    reg [7:0] ch_5;
    reg [7:0] ch_6;
    reg [7:0] ch_7;
    reg [2:0] select;
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
        .ch_4(ch_4),
        .ch_5(ch_5),
        .ch_6(ch_6),
        .ch_7(ch_7),
        .select(select),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Select ch_0", test_num);
        ch_0 = 8'hA5; ch_1 = 8'h00; ch_2 = 8'h00; ch_3 = 8'h00;
        ch_4 = 8'h00; ch_5 = 8'h00; ch_6 = 8'h00; ch_7 = 8'h00;
        select = 3'b000;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Select ch_1", test_num);
        ch_0 = 8'h00; ch_1 = 8'h5A; ch_2 = 8'h00; ch_3 = 8'h00;
        ch_4 = 8'h00; ch_5 = 8'h00; ch_6 = 8'h00; ch_7 = 8'h00;
        select = 3'b001;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Select ch_2", test_num);
        ch_0 = 8'h00; ch_1 = 8'h00; ch_2 = 8'h12; ch_3 = 8'h00;
        ch_4 = 8'h00; ch_5 = 8'h00; ch_6 = 8'h00; ch_7 = 8'h00;
        select = 3'b010;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Select ch_3", test_num);
        ch_0 = 8'h00; ch_1 = 8'h00; ch_2 = 8'h00; ch_3 = 8'h34;
        ch_4 = 8'h00; ch_5 = 8'h00; ch_6 = 8'h00; ch_7 = 8'h00;
        select = 3'b011;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Select ch_4", test_num);
        ch_0 = 8'h00; ch_1 = 8'h00; ch_2 = 8'h00; ch_3 = 8'h00;
        ch_4 = 8'h56; ch_5 = 8'h00; ch_6 = 8'h00; ch_7 = 8'h00;
        select = 3'b100;
        #1;

        check_outputs(8'h56);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Select ch_5", test_num);
        ch_0 = 8'h00; ch_1 = 8'h00; ch_2 = 8'h00; ch_3 = 8'h00;
        ch_4 = 8'h00; ch_5 = 8'h78; ch_6 = 8'h00; ch_7 = 8'h00;
        select = 3'b101;
        #1;

        check_outputs(8'h78);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Select ch_6", test_num);
        ch_0 = 8'h00; ch_1 = 8'h00; ch_2 = 8'h00; ch_3 = 8'h00;
        ch_4 = 8'h00; ch_5 = 8'h00; ch_6 = 8'h9A; ch_7 = 8'h00;
        select = 3'b110;
        #1;

        check_outputs(8'h9A);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Select ch_7", test_num);
        ch_0 = 8'h00; ch_1 = 8'h00; ch_2 = 8'h00; ch_3 = 8'h00;
        ch_4 = 8'h00; ch_5 = 8'h00; ch_6 = 8'h00; ch_7 = 8'hBC;
        select = 3'b111;
        #1;

        check_outputs(8'hBC);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTestcase %0d: Transparency check on ch_0", test_num);
        select = 3'b000;
        ch_0 = 8'h11;
        #1;
        ch_0 = 8'hEE;
        #1;

        check_outputs(8'hEE);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTestcase %0d: Interference check (ch_1 selected, ch_0 changing)", test_num);
        ch_0 = 8'hFF;
        ch_1 = 8'h22;
        select = 3'b001;
        #1;
        ch_0 = 8'h00;
        #1;

        check_outputs(8'h22);
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
