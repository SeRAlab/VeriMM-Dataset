`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] data1_i;
    reg [4:0] data2_i;
    reg select_i;
    wire [4:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data1_i(data1_i),
        .data2_i(data2_i),
        .select_i(select_i),
        .data_o(data_o)
    );
    task testcase001;

        begin
            test_num = 1;
            data1_i = 5'h0A;
            data2_i = 5'h15;
            select_i = 1'b0;
            $display("Test %0d: select_i=0, data1_i=5'h0A, data2_i=5'h15", test_num);
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data1_i = 5'h0A;
            data2_i = 5'h15;
            select_i = 1'b1;
            $display("Test %0d: select_i=1, data1_i=5'h0A, data2_i=5'h15", test_num);
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data1_i = 5'h1F;
            data2_i = 5'h00;
            select_i = 1'b0;
            $display("Test %0d: select_i=0, data1_i=5'h1F, data2_i=5'h00", test_num);
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data1_i = 5'h1F;
            data2_i = 5'h00;
            select_i = 1'b1;
            $display("Test %0d: select_i=1, data1_i=5'h1F, data2_i=5'h00", test_num);
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data1_i = 5'h12;
            data2_i = 5'h09;
            select_i = 1'b0;
            $display("Test %0d: select_i=0, data1_i=5'h12, data2_i=5'h09", test_num);
            #1;

            check_outputs(5'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data1_i = 5'h05;
            data2_i = 5'h1A;
            select_i = 1'b1;
            $display("Test %0d: select_i=1, data1_i=5'h05, data2_i=5'h1A", test_num);
            #1;

            check_outputs(5'h1A);
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
        input [4:0] expected_data_o;
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
