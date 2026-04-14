`timescale 1ns/1ps

module inv_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg enable;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    inv_module dut (
        .data_in(data_in),
        .enable(enable),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Passthrough mode (enable=0) with 0000", test_num);
        enable = 1'b0;
        data_in = 4'b0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Passthrough mode (enable=0) with 1111", test_num);
        enable = 1'b0;
        data_in = 4'b1111;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Passthrough mode (enable=0) with 1010", test_num);
        enable = 1'b0;
        data_in = 4'b1010;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Inversion mode (enable=1) with 0000", test_num);
        enable = 1'b1;
        data_in = 4'b0000;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Inversion mode (enable=1) with 1111", test_num);
        enable = 1'b1;
        data_in = 4'b1111;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Inversion mode (enable=1) with 1010", test_num);
        enable = 1'b1;
        data_in = 4'b1010;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Inversion mode (enable=1) with 0110", test_num);
        enable = 1'b1;
        data_in = 4'b0110;
        #1;

        check_outputs(4'b1001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Toggle check - change enable from 1 to 0", test_num);
        data_in = 4'b1100;
        enable = 1'b1;
        #5;
        enable = 1'b0;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("inv_module Testbench");
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
        input [3:0] expected_data_out;
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
