`timescale 1ns/1ps

module left_shifter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst_n;
    reg [2:0] shift_amount;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    left_shifter dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .shift_amount(shift_amount),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 8'h00;
            shift_amount = 3'b000;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Shift by 0");
            reset_dut();
            data_in = 8'hA5;
            shift_amount = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Shift by 1");
            reset_dut();
            data_in = 8'h01;
            shift_amount = 3'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift by 4");
            reset_dut();
            data_in = 8'h0F;
            shift_amount = 3'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Shift by 7");
            reset_dut();
            data_in = 8'h01;
            shift_amount = 3'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Shift resulting in bit loss");
            reset_dut();
            data_in = 8'hC1;
            shift_amount = 3'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Shift 0xFF by 7");
            reset_dut();
            data_in = 8'hFF;
            shift_amount = 3'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Verify Output is 0 during reset");
            reset_dut();
            rst_n = 0;
            data_in = 8'hFF;
            shift_amount = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
            rst_n = 1;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("left_shifter Testbench");
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
        $dumpvars(0,clk, data_in, rst_n, shift_amount, data_out);
    end

endmodule
