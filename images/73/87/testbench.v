`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data1;
    reg [7:0] data2;
    reg [7:0] data3;
    reg [7:0] data4;
    reg reset;
    wire match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .reset(reset),
        .match(match)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data1 = 8'h00;
            data2 = 8'h00;
            data3 = 8'h00;
            data4 = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %03d: Full Correct Sequence", test_num);

            data1 = 8'b10101010;
            @(posedge clk); #1;

            data2 = 8'b01010101;
            @(posedge clk); #1;

            data3 = 8'b10101010;
            @(posedge clk); #1;

            data4 = 8'b01010101;
            @(posedge clk); #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %03d: Incorrect data1", test_num);

            data1 = 8'b11110000;
            @(posedge clk); #1;

            data2 = 8'b01010101;
            @(posedge clk); #1;

            data3 = 8'b10101010;
            @(posedge clk); #1;

            data4 = 8'b01010101;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %03d: Incorrect data2", test_num);

            data1 = 8'b10101010;
            @(posedge clk); #1;

            data2 = 8'b00001111;
            @(posedge clk); #1;

            data3 = 8'b10101010;
            @(posedge clk); #1;

            data4 = 8'b01010101;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %03d: Incorrect data3", test_num);

            data1 = 8'b10101010;
            @(posedge clk); #1;

            data2 = 8'b01010101;
            @(posedge clk); #1;

            data3 = 8'b00110011;
            @(posedge clk); #1;

            data4 = 8'b01010101;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %03d: Incorrect data4", test_num);

            data1 = 8'b10101010;
            @(posedge clk); #1;

            data2 = 8'b01010101;
            @(posedge clk); #1;

            data3 = 8'b10101010;
            @(posedge clk); #1;

            data4 = 8'b11111111;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %03d: Reset during sequence", test_num);

            data1 = 8'b10101010;
            @(posedge clk); #1;

            data2 = 8'b01010101;
            @(posedge clk); #1;


            reset = 1; @(posedge clk); #1 reset = 0; @(posedge clk); #1;

            data3 = 8'b10101010;
            @(posedge clk); #1;

            data4 = 8'b01010101;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %03d: Back-to-back detection attempt", test_num);


            data1 = 8'hAA; @(posedge clk); #1;
            data2 = 8'h55; @(posedge clk); #1;
            data3 = 8'hAA; @(posedge clk); #1;
            data4 = 8'h55; @(posedge clk); #1;


            data1 = 8'hAA; @(posedge clk); #1;
            data2 = 8'h55; @(posedge clk); #1;
            data3 = 8'hAA; @(posedge clk); #1;
            data4 = 8'h55; @(posedge clk); #1;

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
        input expected_match;
        begin
            if (expected_match === (expected_match ^ match ^ expected_match)) begin
                $display("PASS");
                $display("  Outputs: match=%b",
                         match);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: match=%b",
                         expected_match);
                $display("  Got:      match=%b",
                         match);
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
        $dumpvars(0,clk, data1, data2, data3, data4, reset, match);
    end

endmodule
