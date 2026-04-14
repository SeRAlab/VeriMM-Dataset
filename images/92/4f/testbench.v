`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address0;
    reg [7:0] address1;
    reg [7:0] address2;
    reg ce0;
    reg ce1;
    reg ce2;
    reg clk;
    reg reset;
    wire [7:0] q0;
    wire [7:0] q1;
    wire [7:0] q2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address0(address0),
        .address1(address1),
        .address2(address2),
        .ce0(ce0),
        .ce1(ce1),
        .ce2(ce2),
        .clk(clk),
        .reset(reset),
        .q0(q0),
        .q1(q1),
        .q2(q2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            address0 = 0; ce0 = 0;
            address1 = 0; ce1 = 0;
            address2 = 0; ce2 = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Post-reset read at Address 0", test_num);
            reset_dut();
            address0 = 8'h00; ce0 = 1;
            address1 = 8'h00; ce1 = 1;
            address2 = 8'h00; ce2 = 1;
            #5;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel reads from different addresses", test_num);
            reset_dut();
            address0 = 8'h0A; ce0 = 1;
            address1 = 8'h55; ce1 = 1;
            address2 = 8'hFF; ce2 = 1;
            #5;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Chip Enable disabled check", test_num);
            reset_dut();
            address0 = 8'h11; ce0 = 0;
            address1 = 8'h22; ce1 = 1;
            address2 = 8'h33; ce2 = 1;
            #5;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary address (255) check", test_num);
            reset_dut();
            address0 = 8'd255; ce0 = 1;
            address1 = 8'd255; ce1 = 1;
            address2 = 8'd255; ce2 = 1;
            #5;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous address change check", test_num);
            reset_dut();
            ce0 = 1; ce1 = 1; ce2 = 1;
            address0 = 8'hAA; address1 = 8'hBB; address2 = 8'hCC;
            #2;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
            address0 = 8'h01; address1 = 8'h02; address2 = 8'h03;
            #2;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
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
        input [7:0] expected_q0;
        input [7:0] expected_q1;
        input [7:0] expected_q2;
        begin
            if (expected_q0 === (expected_q0 ^ q0 ^ expected_q0) &&
                expected_q1 === (expected_q1 ^ q1 ^ expected_q1) &&
                expected_q2 === (expected_q2 ^ q2 ^ expected_q2)) begin
                $display("PASS");
                $display("  Outputs: q0=%h, q1=%h, q2=%h",
                         q0, q1, q2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q0=%h, q1=%h, q2=%h",
                         expected_q0, expected_q1, expected_q2);
                $display("  Got:      q0=%h, q1=%h, q2=%h",
                         q0, q1, q2);
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
        $dumpvars(0,address0, address1, address2, ce0, ce1, ce2, clk, reset, q0, q1, q2);
    end

endmodule
