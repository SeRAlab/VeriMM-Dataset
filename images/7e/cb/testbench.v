`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg AR;
    reg CLK;
    reg [7:0] D;
    reg FSM_selector_D;
    wire Data_A;
    wire [30:0] Q_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AR(AR),
        .CLK(CLK),
        .D(D),
        .FSM_selector_D(FSM_selector_D),
        .Data_A(Data_A),
        .Q_reg(Q_reg)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            AR = 1;
            D = 8'h0;
            FSM_selector_D = 1'b0;
            #15;
            AR = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Asynchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 31'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Addition (No Overflow)", test_num);
            reset_dut();

            @(posedge CLK);
            D = 8'h45;
            FSM_selector_D = 1'b1;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 31'h00000045);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: FSM Selector Low (Maintain Value)", test_num);
            reset_dut();

            @(posedge CLK);
            D = 8'h20;
            FSM_selector_D = 1'b1;

            @(posedge CLK);
            D = 8'hFF;
            FSM_selector_D = 1'b0;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 31'h00000020);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 8-bit Overflow Flag (Data_A)", test_num);
            reset_dut();

            @(posedge CLK);
            D = 8'hF0;
            FSM_selector_D = 1'b1;

            @(posedge CLK);

            D = 8'h14;
            FSM_selector_D = 1'b1;

            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 31'h00000104);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large Accumulation (31-bit range)", test_num);
            reset_dut();

            FSM_selector_D = 1'b1;
            D = 8'hFF;



            for (i = 0; i < 10; i = i + 1) begin
                @(posedge CLK);
            end

            #1;
            #1;

            check_outputs(1'b1, 31'h000009F6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data_A Flag Clearing", test_num);
            reset_dut();

            @(posedge CLK);
            D = 8'hFF;
            FSM_selector_D = 1'b1;

            @(posedge CLK);
            D = 8'h01;
            FSM_selector_D = 1'b1;

            @(posedge CLK);

            D = 8'h05;
            FSM_selector_D = 1'b1;

            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0, 31'h00000105);
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
        input expected_Data_A;
        input [30:0] expected_Q_reg;
        begin
            if (expected_Data_A === (expected_Data_A ^ Data_A ^ expected_Data_A) &&
                expected_Q_reg === (expected_Q_reg ^ Q_reg ^ expected_Q_reg)) begin
                $display("PASS");
                $display("  Outputs: Data_A=%b, Q_reg=%h",
                         Data_A, Q_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data_A=%b, Q_reg=%h",
                         expected_Data_A, expected_Q_reg);
                $display("  Got:      Data_A=%b, Q_reg=%h",
                         Data_A, Q_reg);
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
        $dumpvars(0,AR, CLK, D, FSM_selector_D, Data_A, Q_reg);
    end

endmodule
