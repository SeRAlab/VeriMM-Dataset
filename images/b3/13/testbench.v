`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Begin_FSM_FF;
    reg CLK;
    reg [31:0] F;
    reg RST_FF;
    wire ACK_FF;
    wire [31:0] RESULT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Begin_FSM_FF(Begin_FSM_FF),
        .CLK(CLK),
        .F(F),
        .RST_FF(RST_FF),
        .ACK_FF(ACK_FF),
        .RESULT(RESULT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST_FF = 1;
            Begin_FSM_FF = 0;
            F = 32'h0;
            @(posedge CLK);
            #2 RST_FF = 0;
            @(posedge CLK);
            #2;
        end
        endtask
    task run_conversion;

        input [31:0] float_in;
        input [31:0] expected_fixed;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Float=%h", test_num, float_in);


            F = float_in;
            Begin_FSM_FF = 1;
            @(posedge CLK);
            #2;



            wait(ACK_FF == 1);
            Begin_FSM_FF = 0;


            wait(ACK_FF == 0);
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b0, expected_fixed);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            run_conversion(32'h3f800000, 32'h00010000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            run_conversion(32'h40000000, 32'h00020000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            run_conversion(32'h3f000000, 32'h00008000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            run_conversion(32'h41440000, 32'h000c4000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            run_conversion(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            run_conversion(32'h3e000000, 32'h00002000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            run_conversion(32'h42c80000, 32'h00640000);
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
        input expected_ACK_FF;
        input [31:0] expected_RESULT;
        begin
            if (expected_ACK_FF === (expected_ACK_FF ^ ACK_FF ^ expected_ACK_FF) &&
                expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT)) begin
                $display("PASS");
                $display("  Outputs: ACK_FF=%b, RESULT=%h",
                         ACK_FF, RESULT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ACK_FF=%b, RESULT=%h",
                         expected_ACK_FF, expected_RESULT);
                $display("  Got:      ACK_FF=%b, RESULT=%h",
                         ACK_FF, RESULT);
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
        $dumpvars(0,Begin_FSM_FF, CLK, F, RST_FF, ACK_FF, RESULT);
    end

endmodule
