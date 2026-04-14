`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg direction;
    reg [3:0] shift_amount;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .direction(direction),
        .shift_amount(shift_amount),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data = 16'h0;
            direction = 1'b0;
            shift_amount = 4'h0;
            @(posedge clk);
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data = 16'hABCD;
            direction = 1'b1;
            shift_amount = 4'd0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data = 16'h1234;
            direction = 1'b0;
            shift_amount = 4'd0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data = 16'h000F;
            direction = 1'b1;
            shift_amount = 4'd4;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00F0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data = 16'hF000;
            direction = 1'b0;
            shift_amount = 4'd4;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0F00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data = 16'h00FF;
            direction = 1'b1;
            shift_amount = 4'd8;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data = 16'hFF00;
            direction = 1'b0;
            shift_amount = 4'd8;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data = 16'hAAAA;
            direction = 1'b1;
            shift_amount = 4'd1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5554);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            data = 16'h5555;
            direction = 1'b0;
            shift_amount = 4'd1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h2AAA);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            data = 16'hFFFF;
            direction = 1'b1;
            shift_amount = 4'd15;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            data = 16'hFFFF;
            direction = 1'b0;
            shift_amount = 4'd15;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            reset_dut();
            data = 16'hFFFF;
            direction = 1'b1;
            shift_amount = 4'd15;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            reset_dut();
            data = 16'hC0C0;
            direction = 1'b1;
            shift_amount = 4'd2;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0300);
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
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [15:0] expected_q;
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
        $dumpvars(0,clk, data, direction, shift_amount, q);
    end

endmodule
