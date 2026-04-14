`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [27:0] number_i;
    wire [3:0] an_o;
    wire [6:0] seg_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .number_i(number_i),
        .an_o(an_o),
        .seg_o(seg_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            $display("\nResetting/Initializing for Testcase %0d...", test_num + 1);
            number_i = 28'b0;

            repeat(10) @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            number_i = 28'h000007F;



            fork
                begin : wait_an0
                    wait(an_o == 4'b1110);
                    #1;
                    $display("Testcase %0d: Checking Digit 0...", test_num);
                    #1;

                    check_outputs(4'b1110, 7'h7F);
                end
                begin
                    #10000;
                    if (an_o !== 4'b1110) $display("TIMEOUT: Digit 0 not activated");
                end
            join_any
            disable wait_an0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();


            number_i = 28'h0002280;

            fork
                begin : wait_an1
                    wait(an_o == 4'b1101);
                    #1;
                    $display("Testcase %0d: Checking Digit 1...", test_num);
                    #1;

                    check_outputs(4'b1101, 7'h45);
                end
                begin
                    #10000;
                    if (an_o !== 4'b1101) $display("TIMEOUT: Digit 1 not activated");
                end
            join_any
            disable wait_an1;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();


            number_i = 28'h00CC000;

            fork
                begin : wait_an2
                    wait(an_o == 4'b1011);
                    #1;
                    $display("Testcase %0d: Checking Digit 2...", test_num);
                    #1;

                    check_outputs(4'b1011, 7'h33);
                end
                begin
                    #10000;
                    if (an_o !== 4'b1011) $display("TIMEOUT: Digit 2 not activated");
                end
            join_any
            disable wait_an2;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();


            number_i = 28'hB400000;

            fork
                begin : wait_an3
                    wait(an_o == 4'b0111);
                    #1;
                    $display("Testcase %0d: Checking Digit 3...", test_num);
                    #1;

                    check_outputs(4'b0111, 7'h5A);
                end
                begin
                    #10000;
                    if (an_o !== 4'b0111) $display("TIMEOUT: Digit 3 not activated");
                end
            join_any
            disable wait_an3;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();


            number_i = 28'h0208184;

            fork
                begin : wait_mix

                    wait(an_o == 4'b1110);
                    #1;
                    $display("Testcase %0d: Checking Digit 0 in sequence...", test_num);
                    #1;

                    check_outputs(4'b1110, 7'h04);
                end
                begin
                    #10000;
                    if (an_o !== 4'b1110) $display("TIMEOUT: Digit 0 not found");
                end
            join_any
            disable wait_mix;
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
        input [3:0] expected_an_o;
        input [6:0] expected_seg_o;
        begin
            if (expected_an_o === (expected_an_o ^ an_o ^ expected_an_o) &&
                expected_seg_o === (expected_seg_o ^ seg_o ^ expected_seg_o)) begin
                $display("PASS");
                $display("  Outputs: an_o=%h, seg_o=%h",
                         an_o, seg_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: an_o=%h, seg_o=%h",
                         expected_an_o, expected_seg_o);
                $display("  Got:      an_o=%h, seg_o=%h",
                         an_o, seg_o);
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
        $dumpvars(0,clk_i, number_i, an_o, seg_o);
    end

endmodule
