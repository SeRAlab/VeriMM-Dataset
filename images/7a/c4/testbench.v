`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg [3:0] shift_amount;
    wire [15:0] shifted_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .shift_amount(shift_amount),
        .shifted_data(shifted_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data = 16'b0;
            shift_amount = 4'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No shift (shift_amount=0)", test_num);
            reset_dut();
            data = 16'hACE1;
            shift_amount = 4'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hACE1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift left by 1", test_num);
            reset_dut();
            data = 16'h0001;
            shift_amount = 4'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift left by 4", test_num);
            reset_dut();
            data = 16'h1234;
            shift_amount = 4'd4;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h2340);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift left by 8", test_num);
            reset_dut();
            data = 16'h00FF;
            shift_amount = 4'd8;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift left by 15", test_num);
            reset_dut();
            data = 16'h0001;
            shift_amount = 4'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bits shifted out", test_num);
            reset_dut();
            data = 16'hF000;
            shift_amount = 4'd4;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones shifted by 7", test_num);
            reset_dut();
            data = 16'hFFFF;
            shift_amount = 4'd7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFF80);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify registered behavior", test_num);
            reset_dut();


            data = 16'hAAAA;
            shift_amount = 4'd0;
            @(posedge clk);
            #2;


            data = 16'h5555;
            shift_amount = 4'd0;
            #1;

            if (shifted_data === 16'hAAAA) begin
                @(posedge clk);
                #2;
                #1;

                check_outputs(16'h5555);
            end else begin
                $display("FAIL: Output changed before clock edge");
                fail_count = fail_count + 1;
            end
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
        input [15:0] expected_shifted_data;
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
        $dumpvars(0,clk, data, shift_amount, shifted_data);
    end

endmodule
