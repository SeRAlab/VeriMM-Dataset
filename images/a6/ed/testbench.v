`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ALUSrc;
    reg [31:0] datain;
    reg [31:0] num;
    wire [31:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUSrc(ALUSrc),
        .datain(datain),
        .num(num),
        .dataout(dataout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select datain (ALUSrc=0)", test_num);
        ALUSrc = 1'b0;
        datain = 32'h12345678;
        num    = 32'hABCDEF01;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select num (ALUSrc=1)", test_num);
        ALUSrc = 1'b1;
        datain = 32'h12345678;
        num    = 32'hABCDEF01;
        #1;

        check_outputs(32'hABCDEF01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select datain with All Ones (ALUSrc=0)", test_num);
        ALUSrc = 1'b0;
        datain = 32'hFFFFFFFF;
        num    = 32'h00000000;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select num with All Zeros (ALUSrc=1)", test_num);
        ALUSrc = 1'b1;
        datain = 32'hFFFFFFFF;
        num    = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select datain with alternating pattern (ALUSrc=0)", test_num);
        ALUSrc = 1'b0;
        datain = 32'hAAAAAAAA;
        num    = 32'h55555555;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select num with alternating pattern (ALUSrc=1)", test_num);
        ALUSrc = 1'b1;
        datain = 32'hAAAAAAAA;
        num    = 32'h55555555;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Edge case high bit set (ALUSrc=0)", test_num);
        ALUSrc = 1'b0;
        datain = 32'h80000000;
        num    = 32'h7FFFFFFF;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Edge case high bit set (ALUSrc=1)", test_num);
        ALUSrc = 1'b1;
        datain = 32'h80000000;
        num    = 32'h7FFFFFFF;
        #1;

        check_outputs(32'h7FFFFFFF);
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
        input [31:0] expected_dataout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h",
                         expected_dataout);
                $display("  Got:      dataout=%h",
                         dataout);
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
