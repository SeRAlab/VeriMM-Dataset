`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] rx_s;
    reg [31:0] rx_x;
    wire [31:0] tx_x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rx_s(rx_s),
        .rx_x(rx_x),
        .tx_x(tx_x)
    );
    task testcase001;

    begin
        test_num = 1;
        rx_x = 32'h12345678;
        rx_s = 4'd0;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        rx_x = 32'h80000001;
        rx_s = 4'd1;

        #1;


        check_outputs(32'h00000003);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        rx_x = 32'hABCDEF01;
        rx_s = 4'd4;

        #1;


        check_outputs(32'hBCDEF01A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        rx_x = 32'h12345678;
        rx_s = 4'd8;

        #1;


        check_outputs(32'h34567812);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        rx_x = 32'hDEADBEEF;
        rx_s = 4'd12;




        #1;





        check_outputs(32'hBEEFDEAD);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        rx_x = 32'h00000001;
        rx_s = 4'd15;

        #1;


        check_outputs(32'h00008000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        rx_x = 32'hFFFFFFFF;
        rx_s = 4'd7;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        rx_x = 32'h00000000;
        rx_s = 4'd11;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        rx_x = 32'hAAAAAAAA;
        rx_s = 4'd1;

        #1;


        check_outputs(32'h55555555);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        rx_x = 32'hC0000000;
        rx_s = 4'd2;

        #1;


        check_outputs(32'h00000003);
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
        input [31:0] expected_tx_x;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_tx_x === (expected_tx_x ^ tx_x ^ expected_tx_x)) begin
                $display("PASS");
                $display("  Outputs: tx_x=%h",
                         tx_x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_x=%h",
                         expected_tx_x);
                $display("  Got:      tx_x=%h",
                         tx_x);
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
