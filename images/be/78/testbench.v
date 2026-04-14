`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a_in;
    wire [31:0] c_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_in(a_in),
        .c_out(c_out)
    );
    task testcase001;

    begin
        test_num = 1;
        a_in = 32'd0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a_in = 32'd5;
        #1;

        check_outputs(32'h00000005);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a_in = 32'd10;
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a_in = 32'd599;
        #1;

        check_outputs(32'h00000599);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a_in = 32'd600;
        #1;

        check_outputs(32'h00001000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a_in = 32'd7545;
        #1;

        check_outputs(32'h00012345);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a_in = 32'd36000;
        #1;

        check_outputs(32'h00100000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a_in = 32'd36615;
        #1;

        check_outputs(32'h00101015);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a_in = 32'd3599999;
        #1;

        check_outputs(32'h09959599);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a_in = 32'd4455067;
        #1;

        check_outputs(32'h12345067);
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
        input [31:0] expected_c_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c_out === (expected_c_out ^ c_out ^ expected_c_out)) begin
                $display("PASS");
                $display("  Outputs: c_out=%h",
                         c_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_out=%h",
                         expected_c_out);
                $display("  Got:      c_out=%h",
                         c_out);
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
