`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] i_Paddr;
    reg i_Penable;
    reg i_Psel;
    reg i_Pwrite;
    wire o_Rx_En;
    wire o_Str_En;
    wire o_Stw_En;
    wire o_Tx_En;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_Paddr(i_Paddr),
        .i_Penable(i_Penable),
        .i_Psel(i_Psel),
        .i_Pwrite(i_Pwrite),
        .o_Rx_En(o_Rx_En),
        .o_Str_En(o_Str_En),
        .o_Stw_En(o_Stw_En),
        .o_Tx_En(o_Tx_En)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All signals inactive", test_num);
            i_Paddr   = 32'h0000_0000;
            i_Psel    = 0;
            i_Penable = 0;
            i_Pwrite  = 0;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Psel active, Penable inactive", test_num);
            i_Paddr   = 32'h0000_0000;
            i_Psel    = 1;
            i_Penable = 0;
            i_Pwrite  = 1;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Transmission Enable (Tx_En)", test_num);
            i_Paddr   = 32'h0000_0000;
            i_Psel    = 1;
            i_Penable = 1;
            i_Pwrite  = 1;

            #1;


            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Reception Enable (Rx_En)", test_num);
            i_Paddr   = 32'h3FFF_FFFF;
            i_Psel    = 1;
            i_Penable = 1;
            i_Pwrite  = 0;

            #1;


            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Store Enable (Stw_En)", test_num);
            i_Paddr   = 32'h4000_0000;
            i_Psel    = 1;
            i_Penable = 1;
            i_Pwrite  = 1;

            #1;


            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Retrieve Enable (Str_En)", test_num);
            i_Paddr   = 32'h7FFF_FFFF;
            i_Psel    = 1;
            i_Penable = 1;
            i_Pwrite  = 0;

            #1;


            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Unmapped Address 10", test_num);
            i_Paddr   = 32'h8000_0000;
            i_Psel    = 1;
            i_Penable = 1;
            i_Pwrite  = 1;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Unmapped Address 11", test_num);
            i_Paddr   = 32'hC000_0000;
            i_Psel    = 1;
            i_Penable = 1;
            i_Pwrite  = 0;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: Signal drop on Enable deassertion", test_num);

            i_Paddr   = 32'h0000_1234;
            i_Psel    = 1;
            i_Penable = 1;
            i_Pwrite  = 1;
            #2;

            i_Penable = 0;

            #1;


            check_outputs(0, 0, 0, 0);
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
        input expected_o_Rx_En;
        input expected_o_Str_En;
        input expected_o_Stw_En;
        input expected_o_Tx_En;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_Rx_En === (expected_o_Rx_En ^ o_Rx_En ^ expected_o_Rx_En) &&
                expected_o_Str_En === (expected_o_Str_En ^ o_Str_En ^ expected_o_Str_En) &&
                expected_o_Stw_En === (expected_o_Stw_En ^ o_Stw_En ^ expected_o_Stw_En) &&
                expected_o_Tx_En === (expected_o_Tx_En ^ o_Tx_En ^ expected_o_Tx_En)) begin
                $display("PASS");
                $display("  Outputs: o_Rx_En=%b, o_Str_En=%b, o_Stw_En=%b, o_Tx_En=%b",
                         o_Rx_En, o_Str_En, o_Stw_En, o_Tx_En);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_Rx_En=%b, o_Str_En=%b, o_Stw_En=%b, o_Tx_En=%b",
                         expected_o_Rx_En, expected_o_Str_En, expected_o_Stw_En, expected_o_Tx_En);
                $display("  Got:      o_Rx_En=%b, o_Str_En=%b, o_Stw_En=%b, o_Tx_En=%b",
                         o_Rx_En, o_Str_En, o_Stw_En, o_Tx_En);
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
