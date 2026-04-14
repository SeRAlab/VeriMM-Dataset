`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_i00;
    reg [7:0] data_i01;
    reg select;
    wire [7:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_i00(data_i00),
        .data_i01(data_i01),
        .select(select),
        .data_o(data_o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select input 0", test_num);
        data_i00 = 8'hAA;
        data_i01 = 8'h55;
        select = 1'b0;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select input 1", test_num);
        data_i00 = 8'hAA;
        data_i01 = 8'h55;
        select = 1'b1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: All zeros on input 0", test_num);
        data_i00 = 8'h00;
        data_i01 = 8'hFF;
        select = 1'b0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: All ones on input 1", test_num);
        data_i00 = 8'h00;
        data_i01 = 8'hFF;
        select = 1'b1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Random pattern A", test_num);
        data_i00 = 8'h12;
        data_i01 = 8'h34;
        select = 1'b0;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Random pattern B", test_num);
        data_i00 = 8'h12;
        data_i01 = 8'h34;
        select = 1'b1;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Checking bitwise transparency on ch0", test_num);
        data_i00 = 8'hF0;
        data_i01 = 8'h0F;
        select = 1'b0;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Checking bitwise transparency on ch1", test_num);
        data_i00 = 8'hF0;
        data_i01 = 8'h0F;
        select = 1'b1;
        #1;

        check_outputs(8'h0F);
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
        input [7:0] expected_data_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
