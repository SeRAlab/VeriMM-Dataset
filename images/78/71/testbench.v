`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] i_data;
    wire [7:0] o_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_data(i_data),
        .o_data(o_data)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        i_data = 4'd0;
        $display("Test %0d: i_data = %0d (Zero case)", test_num, i_data);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        i_data = 4'd1;
        $display("Test %0d: i_data = %0d (Identity case)", test_num, i_data);
        #1;

        check_outputs(8'd20);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        i_data = 4'd5;
        $display("Test %0d: i_data = %0d", test_num, i_data);
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        i_data = 4'd10;
        $display("Test %0d: i_data = %0d", test_num, i_data);
        #1;

        check_outputs(8'd200);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        i_data = 4'd12;
        $display("Test %0d: i_data = %0d (Max input before 8-bit overflow)", test_num, i_data);
        #1;

        check_outputs(8'd240);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        i_data = 4'd15;
        $display("Test %0d: i_data = %0d (Overflow case: 300 mod 256)", test_num, i_data);

        #1;


        check_outputs(8'd44);
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
        input [7:0] expected_o_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_data === (expected_o_data ^ o_data ^ expected_o_data)) begin
                $display("PASS");
                $display("  Outputs: o_data=%h",
                         o_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data=%h",
                         expected_o_data);
                $display("  Got:      o_data=%h",
                         o_data);
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
