`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    wire [9:0] TERC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .TERC(TERC)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data <= 4'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data <= 4'b0000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data <= 4'b1111;
            @(posedge clk);
            #2;

            #1;


            check_outputs(10'h37B);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data <= 4'b1010;
            @(posedge clk);
            #2;

            #1;


            check_outputs(10'h2D6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data <= 4'b0101;
            @(posedge clk);
            #2;

            #1;


            check_outputs(10'h1AD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data <= 4'b1100;
            @(posedge clk);
            #2;

            #1;


            check_outputs(10'h360);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data <= 4'b0011;
            @(posedge clk);
            #2;

            #1;


            check_outputs(10'h01B);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data <= 4'b1001;
            @(posedge clk);
            #2;

            #1;


            check_outputs(10'h2CD);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            data <= 4'b0110;
            @(posedge clk);
            #2;

            #1;


            check_outputs(10'h1B6);
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
        input [9:0] expected_TERC;
        begin
            if (expected_TERC === (expected_TERC ^ TERC ^ expected_TERC)) begin
                $display("PASS");
                $display("  Outputs: TERC=%h",
                         TERC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TERC=%h",
                         expected_TERC);
                $display("  Got:      TERC=%h",
                         TERC);
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
        $dumpvars(0,clk, data, TERC);
    end

endmodule
