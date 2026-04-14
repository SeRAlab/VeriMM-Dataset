`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr_n;
    reg off;
    reg on;
    reg [3:0] power;
    wire [3:0] T;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr_n(clr_n),
        .off(off),
        .on(on),
        .power(power),
        .T(T)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr_n = 0;
            on = 0;
            off = 0;
            power = 0;
            #20;
            clr_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            on = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            on = 1;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            power = 4'd1;
            on = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            power = 4'd2;
            on = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            on = 1;
            @(posedge clk);
            #1;
            off = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            power = 4'd1;
            on = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            power = 4'd4;
            on = 1;
            @(posedge clk);
            #1;
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
        input [3:0] expected_T;
        begin
            if (expected_T === (expected_T ^ T ^ expected_T)) begin
                $display("PASS");
                $display("  Outputs: T=%h",
                         T);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: T=%h",
                         expected_T);
                $display("  Got:      T=%h",
                         T);
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
        $dumpvars(0,clk, clr_n, off, on, power, T);
    end

endmodule
