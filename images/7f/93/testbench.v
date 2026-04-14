`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg lrck;
    reg reset;
    reg [2:0] sound_code;
    wire [15:0] left_data;
    wire [15:0] right_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .lrck(lrck),
        .reset(reset),
        .sound_code(sound_code),
        .left_data(left_data),
        .right_data(right_data)
    );

    // Clock generation (10ns period)
    initial begin
        lrck = 0;
        forever #5 lrck = ~lrck;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge lrck);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset = 1;
            sound_code = 3'b111;
            @(posedge lrck);
            #1;
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Reset Verification", test_num);
            #1;

            check_outputs(16'h0000, 16'h0000);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            sound_code = 3'b000;
            @(posedge lrck);
            #1;
            test_num = test_num + 1;
            $display("Testcase %03d: Sound Code 000", test_num);
            #1;

            check_outputs({8'h00, expected_samples[0][7:0]}, {8'h00, expected_samples[0][15:8]});
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            sound_code = 3'b001;
            @(posedge lrck);
            #1;
            test_num = test_num + 1;
            $display("Testcase %03d: Sound Code 001", test_num);
            #1;

            check_outputs({8'h00, expected_samples[1][7:0]}, {8'h00, expected_samples[1][15:8]});
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            sound_code = 3'b010;
            @(posedge lrck);
            #1;
            test_num = test_num + 1;
            $display("Testcase %03d: Sound Code 010", test_num);
            #1;

            check_outputs({8'h00, expected_samples[2][7:0]}, {8'h00, expected_samples[2][15:8]});
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            sound_code = 3'b011;
            @(posedge lrck);
            #1;
            test_num = test_num + 1;
            $display("Testcase %03d: Sound Code 011", test_num);
            #1;

            check_outputs({8'h00, expected_samples[3][7:0]}, {8'h00, expected_samples[3][15:8]});
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            sound_code = 3'b100;
            @(posedge lrck);
            #1;
            test_num = test_num + 1;
            $display("Testcase %03d: Sound Code 100", test_num);
            #1;

            check_outputs({8'h00, expected_samples[4][7:0]}, {8'h00, expected_samples[4][15:8]});
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            sound_code = 3'b101;
            @(posedge lrck);
            #1;
            test_num = test_num + 1;
            $display("Testcase %03d: Sound Code 101", test_num);
            #1;

            check_outputs({8'h00, expected_samples[5][7:0]}, {8'h00, expected_samples[5][15:8]});
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            sound_code = 3'b110;
            @(posedge lrck);
            #1;
            test_num = test_num + 1;
            $display("Testcase %03d: Sound Code 110", test_num);
            #1;

            check_outputs({8'h00, expected_samples[6][7:0]}, {8'h00, expected_samples[6][15:8]});
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            sound_code = 3'b111;
            @(posedge lrck);
            #1;
            test_num = test_num + 1;
            $display("Testcase %03d: Sound Code 111", test_num);
            #1;

            check_outputs({8'h00, expected_samples[7][7:0]}, {8'h00, expected_samples[7][15:8]});
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
        testcase009();
        
        
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
        input [15:0] expected_left_data;
        input [15:0] expected_right_data;
        begin
            if (expected_left_data === (expected_left_data ^ left_data ^ expected_left_data) &&
                expected_right_data === (expected_right_data ^ right_data ^ expected_right_data)) begin
                $display("PASS");
                $display("  Outputs: left_data=%h, right_data=%h",
                         left_data, right_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: left_data=%h, right_data=%h",
                         expected_left_data, expected_right_data);
                $display("  Got:      left_data=%h, right_data=%h",
                         left_data, right_data);
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
        $dumpvars(0,lrck, reset, sound_code, left_data, right_data);
    end

endmodule
