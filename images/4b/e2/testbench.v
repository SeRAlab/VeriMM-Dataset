`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [2:0] icm_bi;
    reg ins_i;
    reg rst_i;
    wire ins_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .icm_bi(icm_bi),
        .ins_i(ins_i),
        .rst_i(rst_i),
        .ins_o(ins_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            ins_i = 0;
            icm_bi = 0;
            @(posedge clk_i);
            #1 rst_i = 0;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rising edge, icm=1 (Expected: 1)", test_num);
            reset_dut();
            icm_bi = 3'd1;
            ins_i = 0;
            @(posedge clk_i); #1;
            ins_i = 1;
            @(posedge clk_i); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rising edge, icm=3 (Expected: 1)", test_num);
            reset_dut();
            icm_bi = 3'd3;
            ins_i = 0;
            @(posedge clk_i); #1;
            ins_i = 1;
            @(posedge clk_i); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rising edge, icm=4 (Expected: 1)", test_num);
            reset_dut();
            icm_bi = 3'd4;
            ins_i = 0;
            @(posedge clk_i); #1;
            ins_i = 1;
            @(posedge clk_i); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rising edge, icm=5 (Expected: 1)", test_num);
            reset_dut();
            icm_bi = 3'd5;
            ins_i = 0;
            @(posedge clk_i); #1;
            ins_i = 1;
            @(posedge clk_i); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rising edge, icm=2 (Expected: 0)", test_num);
            reset_dut();
            icm_bi = 3'd2;
            ins_i = 0;
            @(posedge clk_i); #1;
            ins_i = 1;
            @(posedge clk_i); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rising edge, icm=6 (Expected: 0)", test_num);
            reset_dut();
            icm_bi = 3'd6;
            ins_i = 0;
            @(posedge clk_i); #1;
            ins_i = 1;
            @(posedge clk_i); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Falling edge, icm=1 (Expected: 1)", test_num);
            reset_dut();
            icm_bi = 3'd1;
            ins_i = 1;
            @(posedge clk_i); #1;
            ins_i = 0;
            @(posedge clk_i); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Falling edge, icm=2 (Expected: 1)", test_num);
            reset_dut();
            icm_bi = 3'd2;
            ins_i = 1;
            @(posedge clk_i); #1;
            ins_i = 0;
            @(posedge clk_i); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Falling edge, icm=6 (Expected: 1)", test_num);
            reset_dut();
            icm_bi = 3'd6;
            ins_i = 1;
            @(posedge clk_i); #1;
            ins_i = 0;
            @(posedge clk_i); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Falling edge, icm=7 (Expected: 1)", test_num);
            reset_dut();
            icm_bi = 3'd7;
            ins_i = 1;
            @(posedge clk_i); #1;
            ins_i = 0;
            @(posedge clk_i); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Falling edge, icm=3 (Expected: 0)", test_num);
            reset_dut();
            icm_bi = 3'd3;
            ins_i = 1;
            @(posedge clk_i); #1;
            ins_i = 0;
            @(posedge clk_i); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Falling edge, icm=4 (Expected: 0)", test_num);
            reset_dut();
            icm_bi = 3'd4;
            ins_i = 1;
            @(posedge clk_i); #1;
            ins_i = 0;
            @(posedge clk_i); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No transition, icm=1 (Expected: 0)", test_num);
            reset_dut();
            icm_bi = 3'd1;
            ins_i = 1;
            @(posedge clk_i); #1;

            @(posedge clk_i); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset behavior (Expected: 0)", test_num);
            reset_dut();
            icm_bi = 3'd1;
            ins_i = 0;
            @(posedge clk_i); #1;
            rst_i = 1;
            ins_i = 1;
            @(posedge clk_i); #1;
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
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        
        
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
        $dumpvars(0,clk_i, icm_bi, ins_i, rst_i, ins_o);
    end

endmodule
