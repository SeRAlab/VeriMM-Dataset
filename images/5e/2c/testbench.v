`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] D;
    reg clk;
    reg load;
    reg up_down;
    wire [2:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .clk(clk),
        .load(load),
        .up_down(up_down),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 1;
            D = 3'b000;
            up_down = 0;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            load = 1;
            D = 3'b101;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            up_down = 1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            load = 1;
            D = 3'b100;
            @(posedge clk);
            #1;

            load = 0;
            up_down = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            load = 1;
            D = 3'b111;
            @(posedge clk);
            #1;

            load = 0;
            up_down = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            load = 0;
            up_down = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            up_down = 1;
            load = 1;
            D = 3'b110;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b110);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            load = 1; D = 3'b010;
            @(posedge clk);
            #1;

            load = 0; up_down = 0;
            @(posedge clk);
            #1;

            up_down = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b011);
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
        input [2:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clk, load, up_down, Q);
    end

endmodule
