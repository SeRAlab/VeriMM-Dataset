`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ps2_c_i;
    reg ps2_d_i;
    reg reset_i;
    reg sys_clk_i;
    wire [7:0] d_o;
    wire frame_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ps2_c_i(ps2_c_i),
        .ps2_d_i(ps2_d_i),
        .reset_i(reset_i),
        .sys_clk_i(sys_clk_i),
        .d_o(d_o),
        .frame_o(frame_o)
    );

    // Clock generation (10ns period)
    initial begin
        ps2_c_i = 0;
        forever #5 ps2_c_i = ~ps2_c_i;
    end

        task reset_dut;

    begin
        reset_i = 1;
        ps2_d_i = 1;
        #20;
        reset_i = 0;
        #20;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Data 0x55", test_num);
        reset_dut();
        send_byte(8'h55);
        #1;

        check_outputs(8'h55, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Data 0xA2", test_num);
        reset_dut();
        send_byte(8'hA2);
        #1;

        check_outputs(8'hA2, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Data 0x00", test_num);
        reset_dut();
        send_byte(8'h00);
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Data 0xFF", test_num);
        reset_dut();
        send_byte(8'hFF);
        #1;

        check_outputs(8'hFF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Consecutive Frames 0x12, 0x34", test_num);
        reset_dut();
        send_byte(8'h12);

        if (d_o === 8'h12 && frame_o === 1'b1) begin

             send_byte(8'h34);
             #1;

             check_outputs(8'h34, 1'b1);
        end else begin
             $display("Sub-test failed: Byte 1 (0x12) not received correctly.");
             fail_count = fail_count + 1;
        end
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
        input [7:0] expected_d_o;
        input expected_frame_o;
        begin
            if (expected_d_o === (expected_d_o ^ d_o ^ expected_d_o) &&
                expected_frame_o === (expected_frame_o ^ frame_o ^ expected_frame_o)) begin
                $display("PASS");
                $display("  Outputs: d_o=%h, frame_o=%b",
                         d_o, frame_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_o=%h, frame_o=%b",
                         expected_d_o, expected_frame_o);
                $display("  Got:      d_o=%h, frame_o=%b",
                         d_o, frame_o);
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
        $dumpvars(0,ps2_c_i, ps2_d_i, reset_i, sys_clk_i, d_o, frame_o);
    end

endmodule
