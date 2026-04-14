`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] datain;
    reg [31:0] pcin;
    wire [31:0] pcout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .datain(datain),
        .pcin(pcin),
        .pcout(pcout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All Zeros", test_num);
        datain = 32'h00000000;
        pcin = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Minimum Jump Offset", test_num);
        datain = 32'h00000001;
        pcin = 32'h00000000;

        #1;


        check_outputs(32'h00000004);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: PC Upper Nibble Preservation", test_num);
        datain = 32'h00000000;
        pcin = 32'hF0000000;

        #1;


        check_outputs(32'hF0000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Maximum Datain Range", test_num);
        datain = 32'h03FFFFFF;
        pcin = 32'h00000000;

        #1;


        check_outputs(32'h0FFFFFFC);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Mixed Bits and Overflow Handling", test_num);
        datain = 32'hFFFFFFFF;
        pcin = 32'hA0000000;

        #1;


        check_outputs(32'hAFFFFFFC);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Specific Bit Pattern", test_num);
        datain = 32'h02AAAAAA;
        pcin = 32'h50000000;

        #1;


        check_outputs(32'h5AAAAAAC);
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
        input [31:0] expected_pcout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pcout === (expected_pcout ^ pcout ^ expected_pcout)) begin
                $display("PASS");
                $display("  Outputs: pcout=%h",
                         pcout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pcout=%h",
                         expected_pcout);
                $display("  Got:      pcout=%h",
                         pcout);
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
