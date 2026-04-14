`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dbgsel;
    reg [7:0] dval1;
    reg rstn;
    wire [7:0] dout1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dbgsel(dbgsel),
        .dval1(dval1),
        .rstn(rstn),
        .dout1(dout1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            dbgsel = 0;
            dval1 = 0;
            repeat(2) @(posedge clk);
            #1 rstn = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: dbgsel = 84 (Lower Bound In-Range)", test_num);
            dval1 = 8'hA5;
            dbgsel = 8'd84;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: dbgsel = 94 (Upper Bound In-Range)", test_num);
            dval1 = 8'h5A;
            dbgsel = 8'd94;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: dbgsel = 89 (Mid-Range)", test_num);
            dval1 = 8'hFF;
            dbgsel = 8'd89;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: dbgsel = 83 (Out-of-Range Low)", test_num);
            dval1 = 8'h77;
            dbgsel = 8'd83;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: dbgsel = 95 (Out-of-Range High)", test_num);
            dval1 = 8'h88;
            dbgsel = 8'd95;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: dbgsel = 0 (Out-of-Range Min)", test_num);
            dval1 = 8'h12;
            dbgsel = 8'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: dbgsel = 255 (Out-of-Range Max)", test_num);
            dval1 = 8'h34;
            dbgsel = 8'd255;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test %0d: Dynamic data dval1 = 8'hCC, dbgsel = 90", test_num);
            dval1 = 8'hCC;
            dbgsel = 8'd90;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hCC);
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
        input [7:0] expected_dout1;
        begin
            if (expected_dout1 === (expected_dout1 ^ dout1 ^ expected_dout1)) begin
                $display("PASS");
                $display("  Outputs: dout1=%h",
                         dout1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout1=%h",
                         expected_dout1);
                $display("  Got:      dout1=%h",
                         dout1);
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
        $dumpvars(0,clk, dbgsel, dval1, rstn, dout1);
    end

endmodule
