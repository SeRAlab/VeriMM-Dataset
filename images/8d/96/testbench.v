`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ext_spi_clk;
    reg prmry_in;
    wire scndry_out;
    wire scndry_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ext_spi_clk(ext_spi_clk),
        .prmry_in(prmry_in),
        .scndry_out(scndry_out),
        .scndry_out2(scndry_out2)
    );

    // Clock generation (10ns period)
    initial begin
        ext_spi_clk = 0;
        forever #5 ext_spi_clk = ~ext_spi_clk;
    end

        task reset_dut;

        begin
            prmry_in = 0;
            repeat(5) @(posedge ext_spi_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Full Propagation (High)", test_num);
            reset_dut();
            prmry_in = 1;

            repeat(3) @(posedge ext_spi_clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Latency Check (2nd stage)", test_num);
            reset_dut();
            prmry_in = 1;


            repeat(2) @(posedge ext_spi_clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Latency Check (1st stage)", test_num);
            reset_dut();
            prmry_in = 1;


            repeat(1) @(posedge ext_spi_clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Full Propagation (Low transition)", test_num);
            reset_dut();

            prmry_in = 1;
            repeat(4) @(posedge ext_spi_clk);

            prmry_in = 0;
            repeat(3) @(posedge ext_spi_clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Trailing Edge Latency", test_num);
            reset_dut();
            prmry_in = 1;
            repeat(4) @(posedge ext_spi_clk);
            prmry_in = 0;


            repeat(2) @(posedge ext_spi_clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_scndry_out;
        input expected_scndry_out2;
        begin
            if (expected_scndry_out === (expected_scndry_out ^ scndry_out ^ expected_scndry_out) &&
                expected_scndry_out2 === (expected_scndry_out2 ^ scndry_out2 ^ expected_scndry_out2)) begin
                $display("PASS");
                $display("  Outputs: scndry_out=%b, scndry_out2=%b",
                         scndry_out, scndry_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: scndry_out=%b, scndry_out2=%b",
                         expected_scndry_out, expected_scndry_out2);
                $display("  Got:      scndry_out=%b, scndry_out2=%b",
                         scndry_out, scndry_out2);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,ext_spi_clk, prmry_in, scndry_out, scndry_out2);
    end

endmodule
