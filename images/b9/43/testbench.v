`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] input1_vec;
    reg [2:0] input2_a;
    reg [2:0] input2_b;
    reg reset;
    wire input1_o0;
    wire input1_o1;
    wire input1_o2;
    wire [2:0] input1_outv;
    wire [2:0] out_final;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input1_vec(input1_vec),
        .input2_a(input2_a),
        .input2_b(input2_b),
        .reset(reset),
        .input1_o0(input1_o0),
        .input1_o1(input1_o1),
        .input1_o2(input1_o2),
        .input1_outv(input1_outv),
        .out_final(out_final)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input1_vec = 3'b000;
            input2_a = 3'b000;
            input2_b = 3'b000;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 3'b000, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            input1_vec = 3'b000;
            input2_a = 3'b101;
            input2_b = 3'b000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 3'b000, 3'b010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            input1_vec = 3'b001;
            input2_a = 3'b110;
            input2_b = 3'b011;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 3'b001, 3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            input1_vec = 3'b010;
            input2_a = 3'b100;
            input2_b = 3'b010;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 3'b010, 3'b110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            input1_vec = 3'b011;
            input2_a = 3'b111;
            input2_b = 3'b101;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 3'b011, 3'b010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            input1_vec = 3'b111;
            input2_a = 3'b000;
            input2_b = 3'b000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 3'b111, out_final);
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
        input expected_input1_o0;
        input expected_input1_o1;
        input expected_input1_o2;
        input [2:0] expected_input1_outv;
        input [2:0] expected_out_final;
        begin
            if (expected_input1_o0 === (expected_input1_o0 ^ input1_o0 ^ expected_input1_o0) &&
                expected_input1_o1 === (expected_input1_o1 ^ input1_o1 ^ expected_input1_o1) &&
                expected_input1_o2 === (expected_input1_o2 ^ input1_o2 ^ expected_input1_o2) &&
                expected_input1_outv === (expected_input1_outv ^ input1_outv ^ expected_input1_outv) &&
                expected_out_final === (expected_out_final ^ out_final ^ expected_out_final)) begin
                $display("PASS");
                $display("  Outputs: input1_o0=%b, input1_o1=%b, input1_o2=%b, input1_outv=%h, out_final=%h",
                         input1_o0, input1_o1, input1_o2, input1_outv, out_final);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: input1_o0=%b, input1_o1=%b, input1_o2=%b, input1_outv=%h, out_final=%h",
                         expected_input1_o0, expected_input1_o1, expected_input1_o2, expected_input1_outv, expected_out_final);
                $display("  Got:      input1_o0=%b, input1_o1=%b, input1_o2=%b, input1_outv=%h, out_final=%h",
                         input1_o0, input1_o1, input1_o2, input1_outv, out_final);
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
        $dumpvars(0,clk, input1_vec, input2_a, input2_b, reset, input1_o0, input1_o1, input1_o2, input1_outv, out_final);
    end

endmodule
