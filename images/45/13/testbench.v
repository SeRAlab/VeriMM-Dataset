`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Add_regs;
    reg Decr_P;
    reg Load_regs;
    reg Shift_regs;
    reg clock;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg reset;
    wire Nothing;
    wire Q0;
    wire Zero;
    wire [15:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Add_regs(Add_regs),
        .Decr_P(Decr_P),
        .Load_regs(Load_regs),
        .Shift_regs(Shift_regs),
        .clock(clock),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .reset(reset),
        .Nothing(Nothing),
        .Q0(Q0),
        .Zero(Zero),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            Add_regs = 0;
            Decr_P = 0;
            Load_regs = 0;
            Shift_regs = 0;
            multiplicand = 0;
            multiplier = 0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
        end
        endtask
    task run_multiplication;

        input [7:0] a;
        input [7:0] b;
        integer i;
        begin
            multiplicand = a;
            multiplier = b;
            Load_regs = 1;
            @(posedge clock);
            #1 Load_regs = 0;


            for (i = 0; i < 8; i = i + 1) begin

                if (Q0) begin
                    Add_regs = 1;
                    @(posedge clock);
                    #1 Add_regs = 0;
                end

                Shift_regs = 1;
                Decr_P = 1;
                @(posedge clock);
                #1 Shift_regs = 0;
                Decr_P = 0;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 6 * 7", test_num);
            reset_dut();
            run_multiplication(8'd6, 8'd7);

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 16'd42);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 255 * 1", test_num);
            reset_dut();
            run_multiplication(8'd255, 8'd1);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 16'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 10 * 10", test_num);
            reset_dut();
            run_multiplication(8'd10, 8'd10);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 16'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 0 * 255", test_num);
            reset_dut();
            run_multiplication(8'd0, 8'd255);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 255 * 255", test_num);
            reset_dut();
            run_multiplication(8'd255, 8'd255);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 16'd65025);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 128 * 2", test_num);
            reset_dut();
            run_multiplication(8'd128, 8'd2);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 16'd256);
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
        input expected_Nothing;
        input expected_Q0;
        input expected_Zero;
        input [15:0] expected_product;
        begin
            if (expected_Nothing === (expected_Nothing ^ Nothing ^ expected_Nothing) &&
                expected_Q0 === (expected_Q0 ^ Q0 ^ expected_Q0) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero) &&
                expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: Nothing=%b, Q0=%b, Zero=%b, product=%h",
                         Nothing, Q0, Zero, product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Nothing=%b, Q0=%b, Zero=%b, product=%h",
                         expected_Nothing, expected_Q0, expected_Zero, expected_product);
                $display("  Got:      Nothing=%b, Q0=%b, Zero=%b, product=%h",
                         Nothing, Q0, Zero, product);
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
        $dumpvars(0,Add_regs, Decr_P, Load_regs, Shift_regs, clock, multiplicand, multiplier, reset, Nothing, Q0, Zero, product);
    end

endmodule
