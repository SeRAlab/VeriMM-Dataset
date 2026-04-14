`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data_in;
    reg re;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .re(re),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        re = 0;
        forever #5 re = ~re;
    end

        task reset_dut;

        begin
            we = 0;
            data_in = 8'h00;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum boundary value (0x00)", test_num);
            reset_dut();
            @(posedge re);
            we = 1;
            data_in = 8'h00;
            @(posedge re);
            we = 0;
            @(posedge re);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum boundary value (0xFF)", test_num);
            reset_dut();
            @(posedge re);
            we = 1;
            data_in = 8'hFF;
            @(posedge re);
            we = 0;
            @(posedge re);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit pattern (0x55)", test_num);
            reset_dut();
            @(posedge re);
            we = 1;
            data_in = 8'h55;
            @(posedge re);
            we = 0;
            @(posedge re);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit pattern (0xAA)", test_num);
            reset_dut();
            @(posedge re);
            we = 1;
            data_in = 8'hAA;
            @(posedge re);
            we = 0;
            @(posedge re);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit set (0x01)", test_num);
            reset_dut();
            @(posedge re);
            we = 1;
            data_in = 8'h01;
            @(posedge re);
            we = 0;
            @(posedge re);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Nibble-aligned pattern (0x3C)", test_num);
            reset_dut();
            @(posedge re);
            we = 1;
            data_in = 8'h3C;
            @(posedge re);
            we = 0;
            @(posedge re);
            #1;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High nibble set (0xF0)", test_num);
            reset_dut();
            @(posedge re);
            we = 1;
            data_in = 8'hF0;
            @(posedge re);
            we = 0;
            @(posedge re);
            #1;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Low nibble set (0x0F)", test_num);
            reset_dut();
            @(posedge re);
            we = 1;
            data_in = 8'h0F;
            @(posedge re);
            we = 0;
            @(posedge re);
            #1;
            #1;

            check_outputs(8'h0F);
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,data_in, re, we, data_out);
    end

endmodule
