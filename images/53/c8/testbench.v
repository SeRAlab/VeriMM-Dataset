`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg error;
    reg even;
    reg [15:0] ser_t;
    reg ser_tklsb;
    reg ser_tkmsb;
    reg ser_tx_clk;
    wire [15:0] ser_r;
    wire ser_rklsb;
    wire ser_rkmsb;
    wire ser_rx_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .error(error),
        .even(even),
        .ser_t(ser_t),
        .ser_tklsb(ser_tklsb),
        .ser_tkmsb(ser_tkmsb),
        .ser_tx_clk(ser_tx_clk),
        .ser_r(ser_r),
        .ser_rklsb(ser_rklsb),
        .ser_rkmsb(ser_rkmsb),
        .ser_rx_clk(ser_rx_clk)
    );

    // Clock generation (10ns period)
    initial begin
        ser_tx_clk = 0;
        forever #5 ser_tx_clk = ~ser_tx_clk;
    end

        task reset_dut;

        begin
            ser_tx_clk = 0;
            ser_tkmsb = 0;
            ser_tklsb = 0;
            ser_t = 16'h0000;
            even = 0;
            error = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Normal operation (even=1, error=0)", test_num);

            @(posedge ser_tx_clk);
            ser_t = 16'hABCD;
            ser_tkmsb = 1'b1;
            ser_tklsb = 1'b0;
            even = 1'b1;
            error = 1'b0;

            #2;

            #1;


            check_outputs(16'hABCD, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Odd byte alignment (even=0, error=0)", test_num);

            @(posedge ser_tx_clk);
            ser_t = 16'h1234;
            ser_tkmsb = 1'b1;
            ser_tklsb = 1'b0;
            even = 1'b0;
            error = 1'b0;

            #2;

            #1;


            check_outputs(16'h1234, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Error condition (even=1, error=1)", test_num);

            @(posedge ser_tx_clk);
            ser_t = 16'hAAAA;
            ser_tkmsb = 1'b0;
            ser_tklsb = 1'b1;
            even = 1'b1;
            error = 1'b1;

            #2;

            #1;


            check_outputs(16'h5555, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Error condition (even=0, error=1)", test_num);

            @(posedge ser_tx_clk);
            ser_t = 16'h0000;
            ser_tkmsb = 1'b0;
            ser_tklsb = 1'b1;
            even = 1'b0;
            error = 1'b1;

            #2;

            #1;


            check_outputs(16'hFFFF, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Clock signal preservation check", test_num);

            @(negedge ser_tx_clk);
            ser_t = 16'h5A5A;
            ser_tkmsb = 1'b1;
            ser_tklsb = 1'b1;
            even = 1'b1;
            error = 1'b0;

            #2;

            #1;


            check_outputs(16'h5A5A, 1'b1, 1'b1, 1'b0);
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
        input [15:0] expected_ser_r;
        input expected_ser_rklsb;
        input expected_ser_rkmsb;
        input expected_ser_rx_clk;
        begin
            if (expected_ser_r === (expected_ser_r ^ ser_r ^ expected_ser_r) &&
                expected_ser_rklsb === (expected_ser_rklsb ^ ser_rklsb ^ expected_ser_rklsb) &&
                expected_ser_rkmsb === (expected_ser_rkmsb ^ ser_rkmsb ^ expected_ser_rkmsb) &&
                expected_ser_rx_clk === (expected_ser_rx_clk ^ ser_rx_clk ^ expected_ser_rx_clk)) begin
                $display("PASS");
                $display("  Outputs: ser_r=%h, ser_rklsb=%b, ser_rkmsb=%b, ser_rx_clk=%b",
                         ser_r, ser_rklsb, ser_rkmsb, ser_rx_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ser_r=%h, ser_rklsb=%b, ser_rkmsb=%b, ser_rx_clk=%b",
                         expected_ser_r, expected_ser_rklsb, expected_ser_rkmsb, expected_ser_rx_clk);
                $display("  Got:      ser_r=%h, ser_rklsb=%b, ser_rkmsb=%b, ser_rx_clk=%b",
                         ser_r, ser_rklsb, ser_rkmsb, ser_rx_clk);
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
        $dumpvars(0,error, even, ser_t, ser_tklsb, ser_tkmsb, ser_tx_clk, ser_r, ser_rklsb, ser_rkmsb, ser_rx_clk);
    end

endmodule
