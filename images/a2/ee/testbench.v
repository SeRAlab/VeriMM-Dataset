`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data0_i;
    reg [31:0] data1_i;
    reg select_i;
    wire [31:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0_i(data0_i),
        .data1_i(data1_i),
        .select_i(select_i),
        .data_o(data_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select input 0 (Basic Hex)", test_num);
            data0_i = 32'hAAAA_BBBB;
            data1_i = 32'h1111_2222;
            select_i = 1'b0;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select input 1 (Basic Hex)", test_num);
            data0_i = 32'hAAAA_BBBB;
            data1_i = 32'h1111_2222;
            select_i = 1'b1;
            #1;

            check_outputs(32'h1111_2222);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros and Ones (Select 0)", test_num);
            data0_i = 32'hFFFF_FFFF;
            data1_i = 32'h0000_0000;
            select_i = 1'b0;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros and Ones (Select 1)", test_num);
            data0_i = 32'hFFFF_FFFF;
            data1_i = 32'h0000_0000;
            select_i = 1'b1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern Check (Select 0)", test_num);
            data0_i = 32'h1234_5678;
            data1_i = 32'h8765_4321;
            select_i = 1'b0;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern Check (Select 1)", test_num);
            data0_i = 32'h1234_5678;
            data1_i = 32'h8765_4321;
            select_i = 1'b1;
            #1;

            check_outputs(32'h8765_4321);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise Alternating (Select 0)", test_num);
            data0_i = 32'h5555_5555;
            data1_i = 32'hAAAA_AAAA;
            select_i = 1'b0;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise Alternating (Select 1)", test_num);
            data0_i = 32'h5555_5555;
            data1_i = 32'hAAAA_AAAA;
            select_i = 1'b1;
            #1;

            check_outputs(32'hAAAA_AAAA);
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
        input [31:0] expected_data_o;
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
