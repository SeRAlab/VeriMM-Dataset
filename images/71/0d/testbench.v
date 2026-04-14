`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rx_datain;
    wire tx_dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rx_datain(rx_datain),
        .tx_dataout(tx_dataout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rx_datain = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 0 -> Expect 1", test_num);
            reset_dut();

            @(negedge clk);
            rx_datain = 1'b0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1 -> Expect 0", test_num);
            reset_dut();

            @(negedge clk);
            rx_datain = 1'b1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequence 0 -> 1, Expect Final 0", test_num);
            reset_dut();


            @(negedge clk);
            rx_datain = 1'b0;
            @(posedge clk);


            @(negedge clk);
            rx_datain = 1'b1;
            @(posedge clk);

            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequence 1 -> 0, Expect Final 1", test_num);
            reset_dut();


            @(negedge clk);
            rx_datain = 1'b1;
            @(posedge clk);


            @(negedge clk);
            rx_datain = 1'b0;
            @(posedge clk);

            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rapid Toggle Check", test_num);
            reset_dut();

            repeat(4) begin
                @(negedge clk);
                rx_datain = ~rx_datain;
                @(posedge clk);
            end


            #2;
            #1;

            check_outputs(1'b1);
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
        input expected_tx_dataout;
        begin
            if (expected_tx_dataout === (expected_tx_dataout ^ tx_dataout ^ expected_tx_dataout)) begin
                $display("PASS");
                $display("  Outputs: tx_dataout=%b",
                         tx_dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_dataout=%b",
                         expected_tx_dataout);
                $display("  Got:      tx_dataout=%b",
                         tx_dataout);
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
        $dumpvars(0,clk, rx_datain, tx_dataout);
    end

endmodule
