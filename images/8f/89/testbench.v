`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin



            if (out !== 4'b0000) begin
                $display("--- Resetting: Synchronizing to state 0000 ---");
                repeat(8) begin
                    if (out === 4'b0000) break;
                    @(posedge clk);
                end
            end
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            #1;
            $display("Test %0d: State after 1 clock (Expected: 0001)", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: State after 2 clocks (Expected: 0011)", test_num);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            $display("Test %0d: State after 3 clocks (Expected: 0111)", test_num);
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            $display("Test %0d: State after 4 clocks (Expected: 1111)", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            $display("Test %0d: State after 5 clocks (Expected: 1110)", test_num);
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            repeat(6) @(posedge clk);
            #1;
            $display("Test %0d: State after 6 clocks (Expected: 1100)", test_num);
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            repeat(7) @(posedge clk);
            #1;
            $display("Test %0d: State after 7 clocks (Expected: 1000)", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            repeat(8) @(posedge clk);
            #1;
            $display("Test %0d: State after 8 clocks (Full cycle, Expected: 0000)", test_num);
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
        input [3:0] expected_out;
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
        $dumpvars(0,clk, out);
    end

endmodule
