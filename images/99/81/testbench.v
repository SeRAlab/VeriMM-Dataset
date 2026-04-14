`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg en;
    reg load;
    wire ser;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .load(load),
        .ser(ser)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 1;
            data_in = 32'b0;
            en = 0;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load MSB check (Bit 31)", test_num);
            reset_dut();
            data_in = 32'h8000_0000;
            load = 1;
            en = 1;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift once check (Bit 30)", test_num);
            reset_dut();
            data_in = 32'h4000_0000;
            load = 1;
            en = 1;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift 31 times check (Bit 0)", test_num);
            reset_dut();
            data_in = 32'h0000_0001;
            load = 1;
            en = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat(31) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable signal low check", test_num);
            reset_dut();
            data_in = 32'hFFFF_FFFF;
            load = 1;
            en = 0;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros input check", test_num);
            reset_dut();
            data_in = 32'h0000_0000;
            load = 1;
            en = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits (0xAAAAAAAA) shift 1", test_num);
            reset_dut();
            data_in = 32'hAAAA_AAAA;
            load = 1;
            en = 1;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_ser;
        begin
            if (expected_ser === (expected_ser ^ ser ^ expected_ser)) begin
                $display("PASS");
                $display("  Outputs: ser=%b",
                         ser);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ser=%b",
                         expected_ser);
                $display("  Got:      ser=%b",
                         ser);
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
        $dumpvars(0,clk, data_in, en, load, ser);
    end

endmodule
