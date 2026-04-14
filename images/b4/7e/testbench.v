`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [2:0] icm_i;
    reg ins_i;
    wire ins_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .icm_i(icm_i),
        .ins_i(ins_i),
        .ins_o(ins_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            ins_i = 0;
            icm_i = 0;
            repeat(2) @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Rising edge detection (icm_i=1, 0->1 transition)", test_num);
            icm_i = 3'b001;
            ins_i = 0;
            @(posedge clk_i);
            #1 ins_i = 1;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Falling edge detection (icm_i=2, 1->0 transition)", test_num);
            icm_i = 3'b010;
            ins_i = 1;
            @(posedge clk_i);
            @(posedge clk_i);
            #1 ins_i = 0;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Both edge detection (icm_i=3, 0->1 transition)", test_num);
            icm_i = 3'b011;
            ins_i = 0;
            @(posedge clk_i);
            #1 ins_i = 1;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Both edge detection (icm_i=3, 1->0 transition)", test_num);
            icm_i = 3'b011;
            ins_i = 1;
            @(posedge clk_i);
            @(posedge clk_i);
            #1 ins_i = 0;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Rising mode, falling transition (Should be 0)", test_num);
            icm_i = 3'b001;
            ins_i = 1;
            @(posedge clk_i);
            @(posedge clk_i);
            #1 ins_i = 0;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Falling mode, rising transition (Should be 0)", test_num);
            icm_i = 3'b010;
            ins_i = 0;
            @(posedge clk_i);
            #1 ins_i = 1;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: No mode (icm_i=0, 0->1 transition)", test_num);
            icm_i = 3'b000;
            ins_i = 0;
            @(posedge clk_i);
            #1 ins_i = 1;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_ins_o;
        begin
            if (expected_ins_o === (expected_ins_o ^ ins_o ^ expected_ins_o)) begin
                $display("PASS");
                $display("  Outputs: ins_o=%b",
                         ins_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ins_o=%b",
                         expected_ins_o);
                $display("  Got:      ins_o=%b",
                         ins_o);
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
        $dumpvars(0,clk_i, icm_i, ins_i, ins_o);
    end

endmodule
