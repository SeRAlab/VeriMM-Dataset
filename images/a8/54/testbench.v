`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_400Hz;
    reg [15:0] data;
    wire [7:0] sm_duan;
    wire [3:0] sm_wei;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_400Hz(clk_400Hz),
        .data(data),
        .sm_duan(sm_duan),
        .sm_wei(sm_wei)
    );

    // Clock generation (10ns period)
    initial begin
        clk_400Hz = 0;
        forever #5 clk_400Hz = ~clk_400Hz;
    end

        task reset_dut;

        begin
            data = 16'h0000;
            #10;


            @(posedge clk_400Hz);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Checking Digit 0 with value 1", test_num);
            data = 16'h4321;

            while (sm_wei !== 4'b1110) @(posedge clk_400Hz);
            #1;
            #1;

            check_outputs(8'h06, 4'b1110);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Checking Digit 1 with value 2", test_num);
            data = 16'h4321;
            while (sm_wei !== 4'b1101) @(posedge clk_400Hz);
            #1;
            #1;

            check_outputs(8'h5b, 4'b1101);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Checking Digit 2 with value 3", test_num);
            data = 16'h4321;
            while (sm_wei !== 4'b1011) @(posedge clk_400Hz);
            #1;
            #1;

            check_outputs(8'h4f, 4'b1011);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Checking Digit 3 with value 4", test_num);
            data = 16'h4321;
            while (sm_wei !== 4'b0111) @(posedge clk_400Hz);
            #1;
            #1;

            check_outputs(8'h66, 4'b0111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Checking Digit 0 with value 5", test_num);
            data = 16'h8765;
            while (sm_wei !== 4'b1110) @(posedge clk_400Hz);
            #1;
            #1;

            check_outputs(8'h6d, 4'b1110);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Checking Digit 3 with value 8", test_num);
            data = 16'h8765;
            while (sm_wei !== 4'b0111) @(posedge clk_400Hz);
            #1;
            #1;

            check_outputs(8'h7f, 4'b0111);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Checking Digit 3 with value A", test_num);
            data = 16'hABCD;
            while (sm_wei !== 4'b0111) @(posedge clk_400Hz);
            #1;
            #1;

            check_outputs(8'h77, 4'b0111);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Checking Digit 0 with value D", test_num);
            data = 16'hABCD;
            while (sm_wei !== 4'b1110) @(posedge clk_400Hz);
            #1;
            #1;

            check_outputs(8'h5e, 4'b1110);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Checking Digit 1 with value 0", test_num);
            data = 16'hF0FF;
            while (sm_wei !== 4'b1101) @(posedge clk_400Hz);
            #1;
            #1;

            check_outputs(8'h3f, 4'b1101);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Checking Digit 2 with value F", test_num);
            data = 16'hFF00;
            while (sm_wei !== 4'b1011) @(posedge clk_400Hz);
            #1;
            #1;

            check_outputs(8'h71, 4'b1011);
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
        input [7:0] expected_sm_duan;
        input [3:0] expected_sm_wei;
        begin
            if (expected_sm_duan === (expected_sm_duan ^ sm_duan ^ expected_sm_duan) &&
                expected_sm_wei === (expected_sm_wei ^ sm_wei ^ expected_sm_wei)) begin
                $display("PASS");
                $display("  Outputs: sm_duan=%h, sm_wei=%h",
                         sm_duan, sm_wei);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sm_duan=%h, sm_wei=%h",
                         expected_sm_duan, expected_sm_wei);
                $display("  Got:      sm_duan=%h, sm_wei=%h",
                         sm_duan, sm_wei);
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
        $dumpvars(0,clk_400Hz, data, sm_duan, sm_wei);
    end

endmodule
