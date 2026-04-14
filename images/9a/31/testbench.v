`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] control;
    reg [31:0] data_input1;
    reg [31:0] data_input2;
    wire [31:0] data_output;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control(control),
        .data_input1(data_input1),
        .data_input2(data_input2),
        .data_output(data_output),
        .zero(zero)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            control <= 4'b0;
            data_input1 <= 32'b0;
            data_input2 <= 32'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            data_input1 <= 32'd150;
            data_input2 <= 32'd50;
            control <= 4'b0010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd200, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            data_input1 <= 32'd100;
            data_input2 <= 32'd100;
            control <= 4'b0110;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            data_input1 <= 32'hAAAA_FFFF;
            data_input2 <= 32'h5555_FFFF;
            control <= 4'b0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000_FFFF, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            data_input1 <= 32'h1234_0000;
            data_input2 <= 32'h0000_5678;
            control <= 4'b0001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h1234_5678, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            data_input1 <= 32'd10;
            data_input2 <= 32'd20;
            control <= 4'b0111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            data_input1 <= 32'd50;
            data_input2 <= 32'd20;
            control <= 4'b0111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            data_input1 <= 32'h0000_0000;
            data_input2 <= 32'h0000_0000;
            control <= 4'b1100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            data_input1 <= 32'd10;
            data_input2 <= 32'd15;
            control <= 4'b0110;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFF_FFFB, 1'b0);
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
        input [31:0] expected_data_output;
        input expected_zero;
        begin
            if (expected_data_output === (expected_data_output ^ data_output ^ expected_data_output) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: data_output=%h, zero=%b",
                         data_output, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_output=%h, zero=%b",
                         expected_data_output, expected_zero);
                $display("  Got:      data_output=%h, zero=%b",
                         data_output, zero);
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
        $dumpvars(0,clk, control, data_input1, data_input2, data_output, zero);
    end

endmodule
