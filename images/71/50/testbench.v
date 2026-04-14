`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] EN;
    reg aumento;
    reg clk;
    reg disminuye;
    reg rst;
    wire [6:0] cont_year;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN(EN),
        .aumento(aumento),
        .clk(clk),
        .disminuye(disminuye),
        .rst(rst),
        .cont_year(cont_year)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            EN = 0;
            aumento = 0;
            disminuye = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            EN = 2'd2;
            aumento = 1'b1;
            @(posedge clk);
            #1;
            aumento = 1'b0;
            #1;

            check_outputs(7'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            EN = 2'd1;
            aumento = 1'b1;
            repeat(5) @(posedge clk);
            #1;
            aumento = 1'b0;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            EN = 2'd2;
            aumento = 1'b1;
            repeat(15) @(posedge clk);
            #1;
            aumento = 1'b0;
            #1;

            check_outputs(7'd15);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            EN = 2'd2;
            aumento = 1'b1;
            repeat(10) @(posedge clk);
            #1;
            aumento = 1'b0;
            disminuye = 1'b1;
            repeat(4) @(posedge clk);
            #1;
            disminuye = 1'b0;
            #1;

            check_outputs(7'd6);
        end
        endtask

    task testcase006;

        integer i;
        begin
            reset_dut();
            @(posedge clk);
            #1;
            EN = 2'd2;
            aumento = 1'b1;

            repeat(99) @(posedge clk);
            #1;


            @(posedge clk);
            #1;
            aumento = 1'b0;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            EN = 2'd2;
            disminuye = 1'b1;
            @(posedge clk);
            #1;
            disminuye = 1'b0;
            #1;

            check_outputs(7'd99);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            EN = 2'd2;
            aumento = 1'b1;
            repeat(5) @(posedge clk);
            #1;
            aumento = 1'b0;
            disminuye = 1'b0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(7'd5);
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
        input [6:0] expected_cont_year;
        begin
            if (expected_cont_year === (expected_cont_year ^ cont_year ^ expected_cont_year)) begin
                $display("PASS");
                $display("  Outputs: cont_year=%h",
                         cont_year);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cont_year=%h",
                         expected_cont_year);
                $display("  Got:      cont_year=%h",
                         cont_year);
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
        $dumpvars(0,EN, aumento, clk, disminuye, rst, cont_year);
    end

endmodule
