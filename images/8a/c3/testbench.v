`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] addr;
    reg clk;
    reg [6:0] code;
    reg enable;
    wire [3:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .code(code),
        .enable(enable),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        enable = 1;
        code = CODE_RESET;
        addr = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task apply_op;

        input [6:0] op_code;
        input [6:0] op_addr;
        input op_en;
        begin
            @(negedge clk);
            code = op_code;
            addr = op_addr;
            enable = op_en;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset State", test_num);
        reset_dut();
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Set All Bits", test_num);
        reset_dut();
        apply_op(CODE_SET_ALL, 7'h0, 1'b1);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Toggle Bit 1", test_num);
        reset_dut();
        apply_op(CODE_SET_ALL, 7'h0, 1'b1);
        apply_op(CODE_TOGGLE, 7'd1, 1'b1);
        #1;

        check_outputs(4'b1101);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Set Bit 2", test_num);
        reset_dut();
        apply_op(CODE_SET_BIT, 7'd2, 1'b1);
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Clear Bit 3", test_num);
        reset_dut();
        apply_op(CODE_SET_ALL, 7'h0, 1'b1);
        apply_op(CODE_CLEAR_BIT, 7'd3, 1'b1);
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Invert State", test_num);
        reset_dut();
        apply_op(CODE_INVERT, 7'h0, 1'b1);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Left Shift", test_num);
        reset_dut();
        apply_op(CODE_SET_ALL, 7'h0, 1'b1);
        apply_op(CODE_LSHIFT, 7'h0, 1'b1);
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Right Shift", test_num);
        reset_dut();
        apply_op(CODE_SET_ALL, 7'h0, 1'b1);
        apply_op(CODE_RSHIFT, 7'h0, 1'b1);
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable Disabled Check", test_num);
        reset_dut();
        apply_op(CODE_SET_ALL, 7'h0, 1'b0);
        #1;

        check_outputs(4'b0000);
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
        input [3:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,addr, clk, code, enable, state);
    end

endmodule
