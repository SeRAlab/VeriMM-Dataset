`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    reg rotate;
    wire [3:0] shifted_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .rotate(rotate),
        .shifted_data(shifted_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data = 4'b0;
            rotate = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b1000;
            rotate = 0;
            @(posedge clk);
            #1;
            $display("Test %0d: Rotate=0, Data=1000", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b0001;
            rotate = 0;
            @(posedge clk);
            #1;
            $display("Test %0d: Rotate=0, Data=0001", test_num);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b0101;
            rotate = 0;
            @(posedge clk);
            #1;
            $display("Test %0d: Rotate=0, Data=0101", test_num);
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b1111;
            rotate = 0;
            @(posedge clk);
            #1;
            $display("Test %0d: Rotate=0, Data=1111", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b1000;
            rotate = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: Rotate=1, Data=1000 (LSB=0)", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b1001;
            rotate = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: Rotate=1, Data=1001 (LSB=1)", test_num);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b0001;
            rotate = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: Rotate=1, Data=0001 (LSB=1)", test_num);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b0110;
            rotate = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: Rotate=1, Data=0110 (LSB=0)", test_num);
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b1111;
            rotate = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: Rotate=1, Data=1111 (LSB=1)", test_num);
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 4'b0000;
            rotate = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: Rotate=1, Data=0000 (LSB=0)", test_num);
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
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_shifted_data;
        begin
            if (expected_shifted_data === (expected_shifted_data ^ shifted_data ^ expected_shifted_data)) begin
                $display("PASS");
                $display("  Outputs: shifted_data=%h",
                         shifted_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted_data=%h",
                         expected_shifted_data);
                $display("  Got:      shifted_data=%h",
                         shifted_data);
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
        $dumpvars(0,clk, data, rotate, shifted_data);
    end

endmodule
