`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] ra1;
    reg [3:0] ra2;
    reg [3:0] wa3;
    reg [7:0] wd3;
    reg we3;
    wire [7:0] rd1;
    wire [7:0] rd2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ra1(ra1),
        .ra2(ra2),
        .wa3(wa3),
        .wd3(wd3),
        .we3(we3),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we3 = 0;
            wa3 = 0;
            wd3 = 0;
            ra1 = 0;
            ra2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read", test_num);


            we3 = 1; wa3 = 4'd1; wd3 = 8'hA5;
            @(posedge clk); #1;


            we3 = 1; wa3 = 4'd2; wd3 = 8'h5A;
            @(posedge clk); #1;


            we3 = 0;
            ra1 = 4'd1;
            ra2 = 4'd2;
            #2;
            #1;

            check_outputs(8'hA5, 8'h5A);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Register 0 Immutable", test_num);


            we3 = 1; wa3 = 4'd0; wd3 = 8'hFF;
            @(posedge clk); #1;


            we3 = 0;
            ra1 = 4'd0;
            ra2 = 4'd0;
            #2;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Write Enable Control", test_num);


            we3 = 1; wa3 = 4'd5; wd3 = 8'h11;
            @(posedge clk); #1;


            we3 = 0; wa3 = 4'd5; wd3 = 8'hEE;
            @(posedge clk); #1;

            ra1 = 4'd5;
            ra2 = 4'd0;
            #2;
            #1;

            check_outputs(8'h11, 8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Dual Port Read Independence", test_num);


            we3 = 1; wa3 = 4'd10; wd3 = 8'hAA;
            @(posedge clk); #1;
            we3 = 1; wa3 = 4'd15; wd3 = 8'hF0;
            @(posedge clk); #1;

            we3 = 0;
            ra1 = 4'd10;
            ra2 = 4'd15;
            #2;
            #1;

            check_outputs(8'hAA, 8'hF0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Boundary Register 15", test_num);

            we3 = 1; wa3 = 4'd15; wd3 = 8'h77;
            @(posedge clk); #1;

            ra1 = 4'd15;
            ra2 = 4'd0;
            #2;
            #1;

            check_outputs(8'h77, 8'h00);
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
        input [7:0] expected_rd1;
        input [7:0] expected_rd2;
        begin
            if (expected_rd1 === (expected_rd1 ^ rd1 ^ expected_rd1) &&
                expected_rd2 === (expected_rd2 ^ rd2 ^ expected_rd2)) begin
                $display("PASS");
                $display("  Outputs: rd1=%h, rd2=%h",
                         rd1, rd2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd1=%h, rd2=%h",
                         expected_rd1, expected_rd2);
                $display("  Got:      rd1=%h, rd2=%h",
                         rd1, rd2);
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
        $dumpvars(0,clk, ra1, ra2, wa3, wd3, we3, rd1, rd2);
    end

endmodule
