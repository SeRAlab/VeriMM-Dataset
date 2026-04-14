`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg D_offset_cnt_en;
    reg O_offset_cnt_en;
    reg clk_i;
    reg curr_row_load;
    reg next_row_load;
    reg offset_reset;
    reg prev_row_load;
    wire [21:0] adr_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D_offset_cnt_en(D_offset_cnt_en),
        .O_offset_cnt_en(O_offset_cnt_en),
        .clk_i(clk_i),
        .curr_row_load(curr_row_load),
        .next_row_load(next_row_load),
        .offset_reset(offset_reset),
        .prev_row_load(prev_row_load),
        .adr_o(adr_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            D_offset_cnt_en = 0;
            O_offset_cnt_en = 0;
            curr_row_load = 0;
            next_row_load = 0;
            prev_row_load = 0;
            offset_reset = 1;
            @(posedge clk_i);
            #1;
            offset_reset = 0;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            #1;


            check_outputs(22'h000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            O_offset_cnt_en = 1;
            @(posedge clk_i);
            #1;
            O_offset_cnt_en = 0;
            curr_row_load = 1;
            #1;

            #1;


            check_outputs(22'h000280);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            O_offset_cnt_en = 1;
            repeat(5) @(posedge clk_i);
            #1;
            O_offset_cnt_en = 0;
            prev_row_load = 1;
            #1;

            #1;


            check_outputs(22'h000A00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            O_offset_cnt_en = 1;
            repeat(2) @(posedge clk_i);
            #1;
            O_offset_cnt_en = 0;
            next_row_load = 1;
            #1;

            #1;


            check_outputs(22'h000780);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            D_offset_cnt_en = 1;
            repeat(10) @(posedge clk_i);
            #1;
            D_offset_cnt_en = 0;

            #1;

            #1;


            check_outputs(22'h001900);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            O_offset_cnt_en = 1;
            D_offset_cnt_en = 1;
            repeat(3) @(posedge clk_i);
            #1;
            O_offset_cnt_en = 0;
            D_offset_cnt_en = 0;
            curr_row_load = 1;
            #1;

            #1;


            check_outputs(22'h000780);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            O_offset_cnt_en = 1;
            repeat(4) @(posedge clk_i);
            #1;
            O_offset_cnt_en = 0;
            prev_row_load = 1;
            curr_row_load = 1;
            #1;


            #1;



            check_outputs(22'h000780);
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
        input [21:0] expected_adr_o;
        begin
            if (expected_adr_o === (expected_adr_o ^ adr_o ^ expected_adr_o)) begin
                $display("PASS");
                $display("  Outputs: adr_o=%h",
                         adr_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adr_o=%h",
                         expected_adr_o);
                $display("  Got:      adr_o=%h",
                         adr_o);
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
        $dumpvars(0,D_offset_cnt_en, O_offset_cnt_en, clk_i, curr_row_load, next_row_load, offset_reset, prev_row_load, adr_o);
    end

endmodule
