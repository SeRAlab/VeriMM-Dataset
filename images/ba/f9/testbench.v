`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] RX_ADR;
    reg [22:0] RX_DAT;
    reg RX_OK;
    reg [1:0] SW;
    reg [7:0] TX_ADR;
    reg [22:0] TX_DAT;
    reg TX_OK;
    wire [15:0] DATA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RX_ADR(RX_ADR),
        .RX_DAT(RX_DAT),
        .RX_OK(RX_OK),
        .SW(SW),
        .TX_ADR(TX_ADR),
        .TX_DAT(TX_DAT),
        .TX_OK(TX_OK),
        .DATA(DATA)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        TX_ADR = 8'hA5;
        TX_DAT = 23'h123456;
        SW = 2'b00;
        #1;

        check_outputs(16'h56A5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        TX_DAT = 23'h7ABCDE;
        SW = 2'b01;

        #1;


        check_outputs(16'hF579);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        RX_ADR = 8'h33;
        RX_DAT = 23'h0000FF;
        SW = 2'b10;
        #1;

        check_outputs(16'hFF33);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        RX_DAT = 23'h7FFFFF;
        SW = 2'b11;

        #1;


        check_outputs(16'h7FFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        TX_ADR = 8'h00;
        TX_DAT = 23'h000000;
        SW = 2'b00;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        TX_DAT = 23'h400080;
        SW = 2'b01;

        #1;


        check_outputs(16'h8001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        RX_DAT = 23'h400100;
        SW = 2'b11;

        #1;


        check_outputs(16'h4001);
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
        input [15:0] expected_DATA;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DATA === (expected_DATA ^ DATA ^ expected_DATA)) begin
                $display("PASS");
                $display("  Outputs: DATA=%h",
                         DATA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA=%h",
                         expected_DATA);
                $display("  Got:      DATA=%h",
                         DATA);
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
