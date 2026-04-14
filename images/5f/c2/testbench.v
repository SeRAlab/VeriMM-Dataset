`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg [7:0] i_neighbours;
    reg i_reset;
    reg i_val;
    wire o_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_neighbours(i_neighbours),
        .i_reset(i_reset),
        .i_val(i_val),
        .o_val(o_val)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        input val;
        begin
            i_reset = 1;
            i_val = val;
            i_neighbours = 8'b0;
            @(posedge i_clk);
            #1;
            i_reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alive cell with 2 neighbors", test_num);
            reset_dut(1'b1);
            i_neighbours = 8'b0000_0011;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alive cell with 3 neighbors", test_num);
            reset_dut(1'b1);
            i_neighbours = 8'b0000_0111;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alive cell with 1 neighbor", test_num);
            reset_dut(1'b1);
            i_neighbours = 8'b0000_0001;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alive cell with 0 neighbors", test_num);
            reset_dut(1'b1);
            i_neighbours = 8'b0000_0000;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alive cell with 4 neighbors", test_num);
            reset_dut(1'b1);
            i_neighbours = 8'b0000_1111;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alive cell with 8 neighbors", test_num);
            reset_dut(1'b1);
            i_neighbours = 8'b1111_1111;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dead cell with 3 neighbors", test_num);
            reset_dut(1'b0);
            i_neighbours = 8'b0111_0000;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dead cell with 2 neighbors", test_num);
            reset_dut(1'b0);
            i_neighbours = 8'b0011_0000;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dead cell with 4 neighbors", test_num);
            reset_dut(1'b0);
            i_neighbours = 8'b1111_0000;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous reset check", test_num);

            reset_dut(1'b0);

            i_reset = 1;
            i_val = 1;
            i_neighbours = 8'b0000_0000;
            @(posedge i_clk);
            #1;
            i_reset = 0;
            #1;

            check_outputs(1'b1);
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
        input expected_o_val;
        begin
            if (expected_o_val === (expected_o_val ^ o_val ^ expected_o_val)) begin
                $display("PASS");
                $display("  Outputs: o_val=%b",
                         o_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_val=%b",
                         expected_o_val);
                $display("  Got:      o_val=%b",
                         o_val);
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
        $dumpvars(0,i_clk, i_neighbours, i_reset, i_val, o_val);
    end

endmodule
