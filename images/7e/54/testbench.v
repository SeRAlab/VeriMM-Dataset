`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg wb_cyc_i;
    reg wb_rst_i;
    reg wb_stb_i;
    reg wb_we_i;
    wire re_o;
    wire wb_ack_o;
    wire we_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .wb_cyc_i(wb_cyc_i),
        .wb_rst_i(wb_rst_i),
        .wb_stb_i(wb_stb_i),
        .wb_we_i(wb_we_i),
        .re_o(re_o),
        .wb_ack_o(wb_ack_o),
        .we_o(we_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wb_rst_i = 1;
            wb_cyc_i = 0;
            wb_stb_i = 0;
            wb_we_i = 0;
            @(posedge clk);
            #2;
            wb_rst_i = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Idle State", test_num);
            reset_dut();

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Reset Dominance", test_num);
            reset_dut();
            wb_rst_i = 1;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
            wb_rst_i = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Write Operation", test_num);
            reset_dut();
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Read Operation", test_num);
            reset_dut();
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Strobe without Cycle", test_num);
            reset_dut();
            wb_cyc_i = 0;
            wb_stb_i = 1;
            wb_we_i = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Cycle without Strobe", test_num);
            reset_dut();
            wb_cyc_i = 1;
            wb_stb_i = 0;
            wb_we_i = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Back-to-Back Write-Read", test_num);
            reset_dut();


            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i = 1;
            @(posedge clk);
            #1;


            wb_we_i = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Transaction Termination", test_num);
            reset_dut();


            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i = 1;
            @(posedge clk);
            #1;


            wb_cyc_i = 0;
            wb_stb_i = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_re_o;
        input expected_wb_ack_o;
        input expected_we_o;
        begin
            if (expected_re_o === (expected_re_o ^ re_o ^ expected_re_o) &&
                expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_we_o === (expected_we_o ^ we_o ^ expected_we_o)) begin
                $display("PASS");
                $display("  Outputs: re_o=%b, wb_ack_o=%b, we_o=%b",
                         re_o, wb_ack_o, we_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: re_o=%b, wb_ack_o=%b, we_o=%b",
                         expected_re_o, expected_wb_ack_o, expected_we_o);
                $display("  Got:      re_o=%b, wb_ack_o=%b, we_o=%b",
                         re_o, wb_ack_o, we_o);
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
        $dumpvars(0,clk, wb_cyc_i, wb_rst_i, wb_stb_i, wb_we_i, re_o, wb_ack_o, we_o);
    end

endmodule
