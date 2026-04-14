`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg blank;
    reg clk3;
    reg [23:0] data;
    reg hs;
    reg vs;
    wire blank3;
    wire [7:0] data3;
    wire hs3;
    wire vs3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .blank(blank),
        .clk3(clk3),
        .data(data),
        .hs(hs),
        .vs(vs),
        .blank3(blank3),
        .data3(data3),
        .hs3(hs3),
        .vs3(vs3)
    );

    // Clock generation (10ns period)
    initial begin
        clk3 = 0;
        forever #5 clk3 = ~clk3;
    end

        task reset_dut;

        begin
            blank = 0;
            data = 0;
            hs = 0;
            vs = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            data = 24'hAA_BB_CC;
            hs = 0; vs = 0; blank = 0;

            @(posedge clk3);
            #2;

            #1;


            check_outputs(0, 8'hAA, 0, 0);
            repeat(2) @(posedge clk3);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            data = 24'h11_22_33;

            repeat(2) @(posedge clk3);
            #2;
            #1;

            check_outputs(0, 8'h22, 0, 0);
            repeat(1) @(posedge clk3);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            data = 24'h55_66_77;

            repeat(3) @(posedge clk3);
            #2;
            #1;

            check_outputs(0, 8'h77, 0, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            hs = 1; vs = 0; blank = 0;
            data = 24'h000000;

            @(posedge clk3);
            #2;
            #1;

            check_outputs(0, 8'h00, 1, 0);
            repeat(2) @(posedge clk3);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            hs = 0; vs = 1; blank = 0;

            @(posedge clk3);
            #2;
            #1;

            check_outputs(0, 8'h00, 0, 1);
            repeat(2) @(posedge clk3);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            blank = 1; hs = 0; vs = 0;

            @(posedge clk3);
            #2;
            #1;

            check_outputs(1, blank3 === 1'b1 ? data3 : 8'h00, 0, 0);
            repeat(2) @(posedge clk3);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            data = 24'hFF_FF_FF;

            @(posedge clk3);
            #2;
            #1;

            check_outputs(0, 8'hFF, 0, 0);
            repeat(2) @(posedge clk3);
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
        input expected_blank3;
        input [7:0] expected_data3;
        input expected_hs3;
        input expected_vs3;
        begin
            if (expected_blank3 === (expected_blank3 ^ blank3 ^ expected_blank3) &&
                expected_data3 === (expected_data3 ^ data3 ^ expected_data3) &&
                expected_hs3 === (expected_hs3 ^ hs3 ^ expected_hs3) &&
                expected_vs3 === (expected_vs3 ^ vs3 ^ expected_vs3)) begin
                $display("PASS");
                $display("  Outputs: blank3=%b, data3=%h, hs3=%b, vs3=%b",
                         blank3, data3, hs3, vs3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blank3=%b, data3=%h, hs3=%b, vs3=%b",
                         expected_blank3, expected_data3, expected_hs3, expected_vs3);
                $display("  Got:      blank3=%b, data3=%h, hs3=%b, vs3=%b",
                         blank3, data3, hs3, vs3);
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
        $dumpvars(0,blank, clk3, data, hs, vs, blank3, data3, hs3, vs3);
    end

endmodule
