`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] addOut;
    reg sign;
    reg [7:0] subOut;
    wire [7:0] dataInB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addOut(addOut),
        .sign(sign),
        .subOut(subOut),
        .dataInB(dataInB)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select addOut when sign is high", test_num);
        addOut = 8'hA5;
        subOut = 8'h5A;
        sign = 1'b1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select subOut when sign is low", test_num);
        addOut = 8'hA5;
        subOut = 8'h5A;
        sign = 1'b0;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: All ones in addOut, sign high", test_num);
        addOut = 8'hFF;
        subOut = 8'h00;
        sign = 1'b1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: All ones in subOut, sign low", test_num);
        addOut = 8'h00;
        subOut = 8'hFF;
        sign = 1'b0;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Zero values, sign high", test_num);
        addOut = 8'h00;
        subOut = 8'hFF;
        sign = 1'b1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Check specific bit patterns, sign high", test_num);
        addOut = 8'h12;
        subOut = 8'h34;
        sign = 1'b1;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Check specific bit patterns, sign low", test_num);
        addOut = 8'h12;
        subOut = 8'h34;
        sign = 1'b0;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Large hex values, sign high", test_num);
        addOut = 8'hDE;
        subOut = 8'hAD;
        sign = 1'b1;
        #1;

        check_outputs(8'hDE);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Large hex values, sign low", test_num);
        addOut = 8'hBE;
        subOut = 8'hEF;
        sign = 1'b0;
        #1;

        check_outputs(8'hEF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Toggle sign with same inputs", test_num);
        addOut = 8'h77;
        subOut = 8'h88;
        sign = 1'b1;
        #5;
        sign = 1'b0;
        #1;

        check_outputs(8'h88);
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
        input [7:0] expected_dataInB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dataInB === (expected_dataInB ^ dataInB ^ expected_dataInB)) begin
                $display("PASS");
                $display("  Outputs: dataInB=%h",
                         dataInB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataInB=%h",
                         expected_dataInB);
                $display("  Got:      dataInB=%h",
                         dataInB);
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
