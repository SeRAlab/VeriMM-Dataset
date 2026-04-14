`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in_from_fabric_di;
    reg in_from_spi_clk;
    reg in_from_spi_do;
    reg in_from_spi_ss;
    wire out_to_fabric_clk;
    wire out_to_fabric_do;
    wire out_to_fabric_ss;
    wire out_to_spi_di;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_from_fabric_di(in_from_fabric_di),
        .in_from_spi_clk(in_from_spi_clk),
        .in_from_spi_do(in_from_spi_do),
        .in_from_spi_ss(in_from_spi_ss),
        .out_to_fabric_clk(out_to_fabric_clk),
        .out_to_fabric_do(out_to_fabric_do),
        .out_to_fabric_ss(out_to_fabric_ss),
        .out_to_spi_di(out_to_spi_di)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All inputs low", test_num);
            in_from_fabric_di = 1'b0;
            in_from_spi_clk   = 1'b0;
            in_from_spi_do    = 1'b0;
            in_from_spi_ss    = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: All inputs high", test_num);
            in_from_fabric_di = 1'b1;
            in_from_spi_clk   = 1'b1;
            in_from_spi_do    = 1'b1;
            in_from_spi_ss    = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Fabric DI high, others low", test_num);
            in_from_fabric_di = 1'b1;
            in_from_spi_clk   = 1'b0;
            in_from_spi_do    = 1'b0;
            in_from_spi_ss    = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: SPI DO high, others low", test_num);
            in_from_fabric_di = 1'b0;
            in_from_spi_clk   = 1'b0;
            in_from_spi_do    = 1'b1;
            in_from_spi_ss    = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: SPI CLK high, others low", test_num);
            in_from_fabric_di = 1'b0;
            in_from_spi_clk   = 1'b1;
            in_from_spi_do    = 1'b0;
            in_from_spi_ss    = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: SPI SS high, others low", test_num);
            in_from_fabric_di = 1'b0;
            in_from_spi_clk   = 1'b0;
            in_from_spi_do    = 1'b0;
            in_from_spi_ss    = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Mixed pattern (DI=1, DO=0, CLK=1, SS=0)", test_num);
            in_from_fabric_di = 1'b1;
            in_from_spi_clk   = 1'b1;
            in_from_spi_do    = 1'b0;
            in_from_spi_ss    = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Mixed pattern (DI=0, DO=1, CLK=0, SS=1)", test_num);
            in_from_fabric_di = 1'b0;
            in_from_spi_clk   = 1'b0;
            in_from_spi_do    = 1'b1;
            in_from_spi_ss    = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b0);
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
        input expected_out_to_fabric_clk;
        input expected_out_to_fabric_do;
        input expected_out_to_fabric_ss;
        input expected_out_to_spi_di;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_to_fabric_clk === (expected_out_to_fabric_clk ^ out_to_fabric_clk ^ expected_out_to_fabric_clk) &&
                expected_out_to_fabric_do === (expected_out_to_fabric_do ^ out_to_fabric_do ^ expected_out_to_fabric_do) &&
                expected_out_to_fabric_ss === (expected_out_to_fabric_ss ^ out_to_fabric_ss ^ expected_out_to_fabric_ss) &&
                expected_out_to_spi_di === (expected_out_to_spi_di ^ out_to_spi_di ^ expected_out_to_spi_di)) begin
                $display("PASS");
                $display("  Outputs: out_to_fabric_clk=%b, out_to_fabric_do=%b, out_to_fabric_ss=%b, out_to_spi_di=%b",
                         out_to_fabric_clk, out_to_fabric_do, out_to_fabric_ss, out_to_spi_di);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_to_fabric_clk=%b, out_to_fabric_do=%b, out_to_fabric_ss=%b, out_to_spi_di=%b",
                         expected_out_to_fabric_clk, expected_out_to_fabric_do, expected_out_to_fabric_ss, expected_out_to_spi_di);
                $display("  Got:      out_to_fabric_clk=%b, out_to_fabric_do=%b, out_to_fabric_ss=%b, out_to_spi_di=%b",
                         out_to_fabric_clk, out_to_fabric_do, out_to_fabric_ss, out_to_spi_di);
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
