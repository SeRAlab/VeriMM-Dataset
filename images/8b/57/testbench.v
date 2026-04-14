`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] data1;
    reg [31:0] data2;
    wire [15:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data1(data1),
        .data2(data2),
        .data(data)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Inputs set to zero", test_num);
        data1 = 5'b00000;
        data2 = 32'h00000000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max values for significant fields", test_num);
        data1 = 5'b11111;
        data2 = 32'h000000FF;
        #1;

        check_outputs(16'h1FFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying masking of data2 upper bits", test_num);
        data1 = 5'b10101;
        data2 = 32'hFFFFFF55;
        #1;

        check_outputs(16'h1555);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pattern 1 check", test_num);
        data1 = 5'h0F;
        data2 = 32'h12345678;
        #1;

        check_outputs(16'h0F78);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pattern 2 check", test_num);
        data1 = 5'h10;
        data2 = 32'hABCDEFAA;
        #1;

        check_outputs(16'h10AA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating bits pattern", test_num);
        data1 = 5'b01010;
        data2 = 32'h00000055;
        #1;

        check_outputs(16'h0A55);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Lower boundary of data1 and upper of data2", test_num);
        data1 = 5'b00001;
        data2 = 32'h00000080;
        #1;

        check_outputs(16'h0180);
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
        input [15:0] expected_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
