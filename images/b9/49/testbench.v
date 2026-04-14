`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data0_in;
    reg [31:0] data1_in;
    reg [31:0] data2_in;
    reg [1:0] select;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0_in(data0_in),
        .data1_in(data1_in),
        .data2_in(data2_in),
        .select(select),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Selecting data0_in", test_num);
            data0_in = 32'hDEADBEEF;
            data1_in = 32'hCAFEBABE;
            data2_in = 32'h12345678;
            select   = 2'b00;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Selecting data1_in", test_num);
            data0_in = 32'hDEADBEEF;
            data1_in = 32'hCAFEBABE;
            data2_in = 32'h12345678;
            select   = 2'b01;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Selecting data2_in", test_num);
            data0_in = 32'hDEADBEEF;
            data1_in = 32'hCAFEBABE;
            data2_in = 32'h12345678;
            select   = 2'b10;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Inputs Zero, Select 0", test_num);
            data0_in = 32'h00000000;
            data1_in = 32'h00000000;
            data2_in = 32'h00000000;
            select   = 2'b00;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Inputs All-Ones, Select 1", test_num);
            data0_in = 32'hFFFFFFFF;
            data1_in = 32'hFFFFFFFF;
            data2_in = 32'hFFFFFFFF;
            select   = 2'b01;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking Bit Test on data0_in", test_num);
            data0_in = 32'h80000000;
            data1_in = 32'h00000000;
            data2_in = 32'h00000000;
            select   = 2'b00;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Test on data2_in", test_num);
            data0_in = 32'h00000000;
            data1_in = 32'h00000000;
            data2_in = 32'hAAAAAAAA;
            select   = 2'b10;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Switching select while data is constant", test_num);
            data0_in = 32'h11111111;
            data1_in = 32'h22222222;
            data2_in = 32'h33333333;


            select = 2'b00;
            #1;


            select = 2'b01;
            #1;

            check_outputs(32'h22222222);
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
        input [31:0] expected_data_out;
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
