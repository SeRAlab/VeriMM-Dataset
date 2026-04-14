`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr0;
    reg ce0;
    reg clk;
    reg d0;
    reg we0;
    wire q0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr0(addr0),
        .ce0(ce0),
        .clk(clk),
        .d0(d0),
        .we0(we0),
        .q0(q0)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr0 = 0;
            ce0 = 0;
            d0 = 0;
            we0 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            addr0 = 4'h0;
            d0 = 1;
            we0 = 1;
            ce0 = 1;
            @(posedge clk);
            #1;

            we0 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            addr0 = 4'hF;
            d0 = 0;
            we0 = 1;
            ce0 = 1;
            @(posedge clk);
            #1;

            we0 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            addr0 = 4'h5;
            d0 = 1;
            we0 = 1;
            ce0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            addr0 = 4'h7;
            d0 = 1;
            we0 = 1;
            ce0 = 0;
            @(posedge clk);
            #1;

            ce0 = 1;
            we0 = 0;
            @(posedge clk);
            #1;


            if (q0 !== 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: ce0 correctly prevented write.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Write occurred despite ce0 being low.");
            end
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            addr0 = 4'hA; d0 = 1; we0 = 1; ce0 = 1;
            @(posedge clk); #1;

            addr0 = 4'hB; d0 = 0; we0 = 1; ce0 = 1;
            @(posedge clk); #1;

            addr0 = 4'hA; we0 = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;

            addr0 = 4'h3; d0 = 1; we0 = 1; ce0 = 1;
            @(posedge clk); #1;

            addr0 = 4'h3; d0 = 0; we0 = 1; ce0 = 1;
            @(posedge clk); #1;

            we0 = 0;
            @(posedge clk); #1;
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
        input expected_q0;
        begin
            if (expected_q0 === (expected_q0 ^ q0 ^ expected_q0)) begin
                $display("PASS");
                $display("  Outputs: q0=%b",
                         q0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q0=%b",
                         expected_q0);
                $display("  Got:      q0=%b",
                         q0);
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
        $dumpvars(0,addr0, ce0, clk, d0, we0, q0);
    end

endmodule
