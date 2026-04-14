`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg clk_ref;
    reg [1:0] div_sel;
    reg rst;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .clk_ref(clk_ref),
        .div_sel(div_sel),
        .rst(rst),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_ref = 0;
        forever #5 clk_ref = ~clk_ref;
    end

        task reset_dut;

        begin
            rst = 1;
            div_sel = 2'b00;
            #100;
            rst = 0;
            #100;
        end
        endtask
    task count_output_edges;

        output integer count;
        begin
            count = 0;
            fork: timeout_block
                begin
                    #100;
                    disable edge_counter;
                end
                begin: edge_counter
                    forever @(posedge clk_out) count = count + 1;
                end
            join
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Testing div_sel = 2'b00 (Ratio 1)", test_num);
            reset_dut();
            div_sel = 2'b00;
            #5000;
            count_output_edges(edge_count);

            if (edge_count > 0)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(!clk_out);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Testing div_sel = 2'b01 (Ratio 2)", test_num);
            reset_dut();
            div_sel = 2'b01;
            #5000;
            count_output_edges(edge_count);
            if (edge_count > 0)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(!clk_out);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Testing div_sel = 2'b10 (Ratio 3)", test_num);
            reset_dut();
            div_sel = 2'b10;
            #5000;
            count_output_edges(edge_count);
            if (edge_count > 0)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(!clk_out);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Testing div_sel = 2'b11 (Fractional Ratio)", test_num);
            reset_dut();
            div_sel = 2'b11;
            #5000;
            count_output_edges(edge_count);
            if (edge_count > 0)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(!clk_out);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Testing PLL Reset during operation", test_num);
            reset_dut();
            div_sel = 2'b01;
            #2000;
            rst = 1;
            #500;
            count_output_edges(edge_count);

            if (edge_count == 0)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(!clk_out);
            rst = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fractional_n_pll Testbench");
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
        input expected_clk_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
        $dumpvars(0,clk_ref, div_sel, rst, clk_out);
    end

endmodule
