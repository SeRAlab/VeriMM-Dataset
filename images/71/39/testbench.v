`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] amount;
    reg clk;
    reg [31:0] data;
    reg ena;
    reg load;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .amount(amount),
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
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
            data <= 32'h0;
            ena <= 0;
            amount <= 2'b00;
            @(posedge clk);
            load <= 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            load <= 1;
            data <= 32'h0000_0001;
            @(posedge clk);
            load <= 0;
            ena <= 1;
            amount <= 2'b00;
            @(posedge clk);
            ena <= 0;
            #1;
            #1;

            check_outputs(32'h0000_0002);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            load <= 1;
            data <= 32'h0000_0001;
            @(posedge clk);
            load <= 0;
            ena <= 1;
            amount <= 2'b01;
            @(posedge clk);
            ena <= 0;
            #1;
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);
            load <= 1;
            data <= 32'h0000_0004;
            @(posedge clk);
            load <= 0;
            ena <= 1;
            amount <= 2'b10;
            @(posedge clk);
            ena <= 0;
            #1;
            #1;

            check_outputs(32'h0000_0002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk);
            load <= 1;
            data <= 32'h8000_0000;
            @(posedge clk);
            load <= 0;
            ena <= 1;
            amount <= 2'b10;
            @(posedge clk);
            ena <= 0;
            #1;
            #1;

            check_outputs(32'hC000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);
            load <= 1;
            data <= 32'h8000_0000;
            @(posedge clk);
            load <= 0;
            ena <= 1;
            amount <= 2'b11;
            @(posedge clk);
            ena <= 0;
            #1;
            #1;

            check_outputs(32'hE000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(posedge clk);
            load <= 1;
            data <= 32'h4000_0000;
            @(posedge clk);
            load <= 0;
            ena <= 1;
            amount <= 2'b00;
            @(posedge clk);
            amount <= 2'b10;
            @(posedge clk);
            ena <= 0;
            #1;
            #1;

            check_outputs(32'hC000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            @(posedge clk);
            load <= 1;
            data <= 32'h1234_5678;
            @(posedge clk);
            load <= 0;
            ena <= 0;
            amount <= 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            @(posedge clk);
            load <= 1;
            data <= 32'hAAAA_AAAA;
            ena <= 1;
            amount <= 2'b00;
            @(posedge clk);
            load <= 0;
            #1;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            @(posedge clk);
            load <= 1;
            data <= 32'h0000_0001;
            @(posedge clk);
            load <= 0;
            ena <= 1;
            amount <= 2'b01;
            @(posedge clk);
            amount <= 2'b01;
            @(posedge clk);
            amount <= 2'b00;
            @(posedge clk);
            ena <= 0;
            #1;
            #1;

            check_outputs(32'h0000_0020);
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
        input [31:0] expected_q;
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
        $dumpvars(0,amount, clk, data, ena, load, q);
    end

endmodule
