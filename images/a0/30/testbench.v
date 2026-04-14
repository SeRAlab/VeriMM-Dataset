`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg rst_n;
    reg [1:0] sel;
    reg [32:0] word_in;
    wire [127:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .rst_n(rst_n),
        .sel(sel),
        .word_in(word_in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            load = 0;
            sel = 0;
            word_in = 0;
            #15;
            rst_n = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Reset behavior", test_num);
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Load Word 0", test_num);
            @(negedge clk);
            load = 1;
            sel = 2'b00;
            word_in = 32'hAAAA_AAAA;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs({96'h0, 32'hAAAA_AAAA});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Load Word 3", test_num);
            @(negedge clk);
            load = 1;
            sel = 2'b11;
            word_in = 32'hBBBB_BBBB;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs({32'hBBBB_BBBB, 96'h0});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Load All Words", test_num);
            @(negedge clk);
            load = 1;
            sel = 2'b00; word_in = 32'h1111_1111; @(negedge clk);
            sel = 2'b01; word_in = 32'h2222_2222; @(negedge clk);
            sel = 2'b10; word_in = 32'h3333_3333; @(negedge clk);
            sel = 2'b11; word_in = 32'h4444_4444; @(negedge clk);
            load = 0;
            #1;

            check_outputs({32'h4444_4444, 32'h3333_3333, 32'h2222_2222, 32'h1111_1111});
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Disable Load signal", test_num);
            @(negedge clk);
            load = 0;
            sel = 2'b01;
            word_in = 32'hFFFF_FFFF;
            @(negedge clk);
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Overwriting a register", test_num);
            @(negedge clk);
            load = 1;
            sel = 2'b10; word_in = 32'h1234_5678; @(negedge clk);
            sel = 2'b10; word_in = 32'h8765_4321; @(negedge clk);
            load = 0;
            #1;

            check_outputs({32'h0, 32'h8765_4321, 32'h0, 32'h0});
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
        input [127:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, load, rst_n, sel, word_in, out);
    end

endmodule
