`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] datain0;
    reg [31:0] datain1;
    reg [31:0] datain2;
    reg [31:0] datain3;
    reg [1:0] select;
    wire [31:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .datain0(datain0),
        .datain1(datain1),
        .datain2(datain2),
        .datain3(datain3),
        .select(select),
        .dataout(dataout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select datain0", test_num);
            datain0 = 32'hAAAAAAAA;
            datain1 = 32'hBBBBBBBB;
            datain2 = 32'hCCCCCCCC;
            datain3 = 32'hDDDDDDDD;
            select  = 2'b00;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select datain1", test_num);
            datain0 = 32'h11111111;
            datain1 = 32'h22222222;
            datain2 = 32'h33333333;
            datain3 = 32'h44444444;
            select  = 2'b01;
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select datain2", test_num);
            datain0 = 32'hDEADBEEF;
            datain1 = 32'hCAFEBABE;
            datain2 = 32'h00C0FFEE;
            datain3 = 32'hBAADF00D;
            select  = 2'b10;
            #1;

            check_outputs(32'h00C0FFEE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select datain3", test_num);
            datain0 = 32'h00000000;
            datain1 = 32'hFFFFFFFF;
            datain2 = 32'h55555555;
            datain3 = 32'h99999999;
            select  = 2'b11;
            #1;

            check_outputs(32'h99999999);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: All bits set on datain2", test_num);
            datain0 = 32'h0;
            datain1 = 32'h0;
            datain2 = 32'hFFFFFFFF;
            datain3 = 32'h0;
            select  = 2'b10;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Checkerboard pattern on datain1", test_num);
            datain0 = 32'h0;
            datain1 = 32'h55AA55AA;
            datain2 = 32'h0;
            datain3 = 32'h0;
            select  = 2'b01;
            #1;

            check_outputs(32'h55AA55AA);
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
