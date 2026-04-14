`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk0;
    reg clk1;
    reg clk2;
    reg clk3;
    reg [7:0] data0;
    reg [7:0] data1;
    reg [7:0] data2;
    reg resetn;
    reg wen0;
    reg wen1;
    reg wen2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk0(clk0),
        .clk1(clk1),
        .clk2(clk2),
        .clk3(clk3),
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .resetn(resetn),
        .wen0(wen0),
        .wen1(wen1),
        .wen2(wen2)
    );
    task testcase001;

        begin
            test_num = 1;
            resetn = 0;
            clk0 = 1; clk1 = 1; clk2 = 1; clk3 = 1;
            wen0 = 1; wen1 = 1; wen2 = 1;
            data0 = 8'hFF; data1 = 8'hFF; data2 = 8'hFF;

            exp_clk = 4'b0000;
            exp_wen = 3'b000;
            exp_data = 24'h000000;

            #10;
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            resetn = 0; #5; resetn = 1;
            clk0 = 1; clk1 = 0; clk2 = 1; clk3 = 0;
            wen0 = 1; wen1 = 1; wen2 = 0;
            data0 = 8'hAA; data1 = 8'hBB; data2 = 8'hCC;

            exp_clk = 4'b0101;
            exp_wen = 3'b011;
            exp_data = 24'hCCBBAA;

            #10;
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            resetn = 0; #5; resetn = 1;
            clk0 = 0; clk1 = 1; clk2 = 1; clk3 = 1;
            wen0 = 0; wen1 = 0; wen2 = 1;
            data0 = 8'h12; data1 = 8'h34; data2 = 8'h56;

            exp_clk = 4'b1110;
            exp_wen = 3'b100;
            exp_data = 24'h563412;

            #10;
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            resetn = 0; #5; resetn = 1;
            clk0 = 1; clk1 = 1; clk2 = 1; clk3 = 1;
            wen0 = 1; wen1 = 1; wen2 = 1;
            data0 = 8'hFF; data1 = 8'hFF; data2 = 8'hFF;

            exp_clk = 4'b1111;
            exp_wen = 3'b111;
            exp_data = 24'hFFFFFF;

            #10;
            #1;

            check_outputs();
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            resetn = 0; #5; resetn = 1;
            clk0 = 0; clk1 = 0; clk2 = 0; clk3 = 0;
            wen0 = 0; wen1 = 0; wen2 = 0;
            data0 = 8'h00; data1 = 8'h00; data2 = 8'h00;

            exp_clk = 4'b0000;
            exp_wen = 3'b000;
            exp_data = 24'h000000;

            #10;
            #1;

            check_outputs();
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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

endmodule
