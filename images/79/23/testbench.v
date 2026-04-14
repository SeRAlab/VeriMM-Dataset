`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg pllenable;
    reg pllreset;
    reg [3:0] rxanalogreset;
    reg [3:0] rxdigitalreset;
    reg [3:0] txdigitalreset;
    wire pllresetout;
    wire [3:0] rxanalogresetout;
    wire [3:0] rxdigitalresetout;
    wire [3:0] txanalogresetout;
    wire [3:0] txdigitalresetout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pllenable(pllenable),
        .pllreset(pllreset),
        .rxanalogreset(rxanalogreset),
        .rxdigitalreset(rxdigitalreset),
        .txdigitalreset(txdigitalreset),
        .pllresetout(pllresetout),
        .rxanalogresetout(rxanalogresetout),
        .rxdigitalresetout(rxdigitalresetout),
        .txanalogresetout(txanalogresetout),
        .txdigitalresetout(txdigitalresetout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All signals zero", test_num);
            pllenable = 0;
            pllreset = 0;
            rxanalogreset = 4'b0000;
            txdigitalreset = 4'b0000;
            rxdigitalreset = 4'b0000;


            #1;



            check_outputs(1'b0, 4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Assert PLL Reset", test_num);
            pllenable = 1;
            pllreset = 1;
            rxanalogreset = 4'b0000;
            txdigitalreset = 4'b0000;
            rxdigitalreset = 4'b0000;


            #1;



            check_outputs(1'b1, 4'h0, 4'h0, 4'hF, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: RX Analog Reset patterns", test_num);
            pllenable = 1;
            pllreset = 0;
            rxanalogreset = 4'b1010;
            txdigitalreset = 4'b0000;
            rxdigitalreset = 4'b0000;


            #1;



            check_outputs(1'b0, 4'hA, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: TX Digital Reset patterns", test_num);
            pllenable = 1;
            pllreset = 0;
            rxanalogreset = 4'b0000;
            txdigitalreset = 4'b1100;
            rxdigitalreset = 4'b0000;


            #1;



            check_outputs(1'b0, 4'h0, 4'h0, 4'h0, 4'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: RX Digital Reset patterns", test_num);
            pllenable = 1;
            pllreset = 0;
            rxanalogreset = 4'b0000;
            txdigitalreset = 4'b0000;
            rxdigitalreset = 4'b0011;


            #1;



            check_outputs(1'b0, 4'h0, 4'h3, 4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: All resets active high", test_num);
            pllenable = 1;
            pllreset = 1;
            rxanalogreset = 4'b1111;
            txdigitalreset = 4'b1111;
            rxdigitalreset = 4'b1111;


            #1;



            check_outputs(1'b1, 4'hF, 4'hF, 4'hF, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Toggle pllenable with active inputs", test_num);
            pllenable = 0;
            pllreset = 1;
            rxanalogreset = 4'b0101;
            txdigitalreset = 4'b1010;
            rxdigitalreset = 4'b1111;



            #1;




            check_outputs(1'b1, 4'h5, 4'hF, 4'hF, 4'hA);
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
        input expected_pllresetout;
        input [3:0] expected_rxanalogresetout;
        input [3:0] expected_rxdigitalresetout;
        input [3:0] expected_txanalogresetout;
        input [3:0] expected_txdigitalresetout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pllresetout === (expected_pllresetout ^ pllresetout ^ expected_pllresetout) &&
                expected_rxanalogresetout === (expected_rxanalogresetout ^ rxanalogresetout ^ expected_rxanalogresetout) &&
                expected_rxdigitalresetout === (expected_rxdigitalresetout ^ rxdigitalresetout ^ expected_rxdigitalresetout) &&
                expected_txanalogresetout === (expected_txanalogresetout ^ txanalogresetout ^ expected_txanalogresetout) &&
                expected_txdigitalresetout === (expected_txdigitalresetout ^ txdigitalresetout ^ expected_txdigitalresetout)) begin
                $display("PASS");
                $display("  Outputs: pllresetout=%b, rxanalogresetout=%h, rxdigitalresetout=%h, txanalogresetout=%h, txdigitalresetout=%h",
                         pllresetout, rxanalogresetout, rxdigitalresetout, txanalogresetout, txdigitalresetout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pllresetout=%b, rxanalogresetout=%h, rxdigitalresetout=%h, txanalogresetout=%h, txdigitalresetout=%h",
                         expected_pllresetout, expected_rxanalogresetout, expected_rxdigitalresetout, expected_txanalogresetout, expected_txdigitalresetout);
                $display("  Got:      pllresetout=%b, rxanalogresetout=%h, rxdigitalresetout=%h, txanalogresetout=%h, txdigitalresetout=%h",
                         pllresetout, rxanalogresetout, rxdigitalresetout, txanalogresetout, txdigitalresetout);
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
