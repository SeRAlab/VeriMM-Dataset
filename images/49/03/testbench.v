`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg mb_type_i;
    reg [5:0] qp_i;
    wire [4:0] tc_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mb_type_i(mb_type_i),
        .qp_i(qp_i),
        .tc_o(tc_o)
    );
    task testcase001;

    begin
        test_num = 1;
        qp_i = 6'd0;
        mb_type_i = 1'b0;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        qp_i = 6'd31;
        mb_type_i = 1'b0;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        qp_i = 6'd32;
        mb_type_i = 1'b0;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        qp_i = 6'd51;
        mb_type_i = 1'b0;
        #1;

        check_outputs(5'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        qp_i = 6'd63;
        mb_type_i = 1'b0;
        #1;

        check_outputs(5'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        qp_i = 6'd0;
        mb_type_i = 1'b1;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        qp_i = 6'd27;
        mb_type_i = 1'b1;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        qp_i = 6'd40;
        mb_type_i = 1'b1;
        #1;

        check_outputs(5'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        qp_i = 6'd51;
        mb_type_i = 1'b1;
        #1;

        check_outputs(5'd10);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        qp_i = 6'd44;
        mb_type_i = 1'b0;
        #1;

        check_outputs(5'd2);
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
        input [4:0] expected_tc_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_tc_o === (expected_tc_o ^ tc_o ^ expected_tc_o)) begin
                $display("PASS");
                $display("  Outputs: tc_o=%h",
                         tc_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tc_o=%h",
                         expected_tc_o);
                $display("  Got:      tc_o=%h",
                         tc_o);
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
