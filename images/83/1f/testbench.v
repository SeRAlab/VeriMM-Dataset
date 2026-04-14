`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] ctrl;
    wire [3:0] td_mode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .td_mode(td_mode)
    );
    task testcase001;

    begin
        test_num = 1;
        ctrl = 9'b000_000000;


        #1;



        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ctrl = 9'b001_000000;

        #1;


        check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ctrl = 9'b010_101010;

        #1;


        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ctrl = 9'b011_111111;

        #1;


        check_outputs(4'b0011);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ctrl = 9'b100_010101;

        #1;


        check_outputs(4'b0100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ctrl = 9'b101_000000;

        #1;


        check_outputs(4'b0101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        ctrl = 9'b110_110011;

        #1;


        check_outputs(4'b0110);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        ctrl = 9'b111_001100;

        #1;


        check_outputs(4'b0111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;

        ctrl = 9'b001_111000;
        #1;

        check_outputs(4'b0001);
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
        input [3:0] expected_td_mode;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_td_mode === (expected_td_mode ^ td_mode ^ expected_td_mode)) begin
                $display("PASS");
                $display("  Outputs: td_mode=%h",
                         td_mode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: td_mode=%h",
                         expected_td_mode);
                $display("  Got:      td_mode=%h",
                         td_mode);
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
