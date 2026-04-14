`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg shift_right;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .shift_right(shift_right),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load <= 1;
            data_in <= 8'h00;
            shift_right <= 0;
            @(posedge clk);
            load <= 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            @(posedge clk);
            load <= 1;
            data_in <= 8'hA5;
            @(posedge clk);
            load <= 0;
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            @(posedge clk);
            load <= 1;
            data_in <= 8'h80;
            @(posedge clk);

            load <= 0;
            shift_right <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            @(posedge clk);
            load <= 1;
            data_in <= 8'h01;
            @(posedge clk);

            load <= 0;
            shift_right <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            @(posedge clk);
            load <= 1;
            data_in <= 8'hF0;
            @(posedge clk);
            load <= 0;
            shift_right <= 1;
            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            @(posedge clk);
            load <= 1;
            data_in <= 8'h0F;
            @(posedge clk);
            load <= 0;
            shift_right <= 0;
            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            @(posedge clk);
            load <= 1;
            data_in <= 8'hAA;
            shift_right <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            @(posedge clk);
            load <= 1;
            data_in <= 8'h01;
            @(posedge clk);
            load <= 0;
            shift_right <= 1;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            @(posedge clk);
            load <= 1;
            data_in <= 8'h80;
            @(posedge clk);
            load <= 0;
            shift_right <= 0;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data_in, load, shift_right, q);
    end

endmodule
