`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg [1:0] fnc;
    reg [4:0] shamt;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .fnc(fnc),
        .shamt(shamt),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            data_in <= 0;
            fnc     <= 0;
            shamt   <= 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: SLL - Shift 1 bit left", test_num);
            data_in <= 32'h0000_0001;
            shamt   <= 5'd1;
            fnc     <= 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0002);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: SLL - Shift 16 bits left", test_num);
            data_in <= 32'h0000_FFFF;
            shamt   <= 5'd16;
            fnc     <= 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF_0000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: SLR - Logical Right Shift (Zero Fill)", test_num);
            data_in <= 32'h8000_0000;
            shamt   <= 5'd1;
            fnc     <= 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h4000_0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: SLR - Shift 8 bits right", test_num);
            data_in <= 32'hFF00_FF00;
            shamt   <= 5'd8;
            fnc     <= 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00FF_00FF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: SAR - Positive number (Zero Extension)", test_num);
            data_in <= 32'h7000_0000;
            shamt   <= 5'd4;
            fnc     <= 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0700_0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %03d: SAR - Negative number (Sign Extension)", test_num);
            data_in <= 32'h8000_0000;
            shamt   <= 5'd4;
            fnc     <= 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hF800_0000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %03d: No Shift (shamt=0)", test_num);
            data_in <= 32'hABCD_EF12;
            shamt   <= 5'd0;
            fnc     <= 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hABCD_EF12);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %03d: SAR - Maximum shift on negative value", test_num);
            data_in <= 32'hF000_0000;
            shamt   <= 5'd31;
            fnc     <= 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, fnc, shamt, data_out);
    end

endmodule
