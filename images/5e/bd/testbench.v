`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] ADDR_IN1;
    reg [3:0] ADDR_IN2;
    reg [3:0] ADDR_OUT1;
    reg [3:0] ADDR_OUT2;
    reg [3:0] ADDR_OUT3;
    reg CLK;
    reg [7:0] D_IN1;
    reg [7:0] D_IN2;
    reg WE1;
    reg WE2;
    reg rst_n;
    wire [7:0] D_OUT1;
    wire [7:0] D_OUT2;
    wire [7:0] D_OUT3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR_IN1(ADDR_IN1),
        .ADDR_IN2(ADDR_IN2),
        .ADDR_OUT1(ADDR_OUT1),
        .ADDR_OUT2(ADDR_OUT2),
        .ADDR_OUT3(ADDR_OUT3),
        .CLK(CLK),
        .D_IN1(D_IN1),
        .D_IN2(D_IN2),
        .WE1(WE1),
        .WE2(WE2),
        .rst_n(rst_n),
        .D_OUT1(D_OUT1),
        .D_OUT2(D_OUT2),
        .D_OUT3(D_OUT3)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            rst_n = 0;
            WE1 = 0;
            WE2 = 0;
            ADDR_IN1 = 0;
            ADDR_IN2 = 0;
            D_IN1 = 0;
            D_IN2 = 0;
            ADDR_OUT1 = 0;
            ADDR_OUT2 = 0;
            ADDR_OUT3 = 0;
            #15;
            rst_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Verify Reset", test_num);
            reset_dut();

            ADDR_OUT1 = 4'h0;
            ADDR_OUT2 = 4'h7;
            ADDR_OUT3 = 4'hF;
            #5;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Port Write (Port 1)", test_num);
            reset_dut();
            @(negedge CLK);
            WE1 = 1;
            ADDR_IN1 = 4'h5;
            D_IN1 = 8'hA5;
            @(posedge CLK);
            #2;
            WE1 = 0;
            ADDR_OUT1 = 4'h5;
            ADDR_OUT2 = 4'h0;
            ADDR_OUT3 = 4'h0;
            #5;
            #1;

            check_outputs(8'hA5, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Simultaneous Dual Port Write", test_num);
            reset_dut();
            @(negedge CLK);
            WE1 = 1; ADDR_IN1 = 4'h1; D_IN1 = 8'h11;
            WE2 = 1; ADDR_IN2 = 4'h2; D_IN2 = 8'h22;
            @(posedge CLK);
            #2;
            WE1 = 0; WE2 = 0;
            ADDR_OUT1 = 4'h1;
            ADDR_OUT2 = 4'h2;
            ADDR_OUT3 = 4'h0;
            #5;
            #1;

            check_outputs(8'h11, 8'h22, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Write Enable Logic Verification", test_num);
            reset_dut();
            @(negedge CLK);
            WE1 = 0;
            ADDR_IN1 = 4'h8;
            D_IN1 = 8'hFF;
            @(posedge CLK);
            #2;
            ADDR_OUT1 = 4'h8;
            ADDR_OUT2 = 4'h0;
            ADDR_OUT3 = 4'h0;
            #5;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Triple Port Read", test_num);
            reset_dut();

            @(negedge CLK);
            WE1 = 1; ADDR_IN1 = 4'h1; D_IN1 = 8'h10;
            WE2 = 1; ADDR_IN2 = 4'h2; D_IN2 = 8'h20;
            @(posedge CLK);
            @(negedge CLK);
            WE1 = 1; ADDR_IN1 = 4'h3; D_IN1 = 8'h30;
            WE2 = 0;
            @(posedge CLK);
            #2;
            WE1 = 0;
            ADDR_OUT1 = 4'h1;
            ADDR_OUT2 = 4'h2;
            ADDR_OUT3 = 4'h3;
            #5;
            #1;

            check_outputs(8'h10, 8'h20, 8'h30);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Overwrite Verification", test_num);
            reset_dut();
            @(negedge CLK);
            WE1 = 1; ADDR_IN1 = 4'hC; D_IN1 = 8'hAA;
            @(posedge CLK);
            @(negedge CLK);
            WE1 = 1; ADDR_IN1 = 4'hC; D_IN1 = 8'hBB;
            @(posedge CLK);
            #2;
            WE1 = 0;
            ADDR_OUT1 = 4'hC;
            ADDR_OUT2 = 4'hC;
            ADDR_OUT3 = 4'hC;
            #5;
            #1;

            check_outputs(8'hBB, 8'hBB, 8'hBB);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Read-After-Write Synchronization", test_num);
            reset_dut();
            @(negedge CLK);
            WE1 = 1; ADDR_IN1 = 4'hE; D_IN1 = 8'hEE;
            ADDR_OUT1 = 4'hE;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(8'hEE, 8'h00, 8'h00);
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
        input [7:0] expected_D_OUT1;
        input [7:0] expected_D_OUT2;
        input [7:0] expected_D_OUT3;
        begin
            if (expected_D_OUT1 === (expected_D_OUT1 ^ D_OUT1 ^ expected_D_OUT1) &&
                expected_D_OUT2 === (expected_D_OUT2 ^ D_OUT2 ^ expected_D_OUT2) &&
                expected_D_OUT3 === (expected_D_OUT3 ^ D_OUT3 ^ expected_D_OUT3)) begin
                $display("PASS");
                $display("  Outputs: D_OUT1=%h, D_OUT2=%h, D_OUT3=%h",
                         D_OUT1, D_OUT2, D_OUT3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_OUT1=%h, D_OUT2=%h, D_OUT3=%h",
                         expected_D_OUT1, expected_D_OUT2, expected_D_OUT3);
                $display("  Got:      D_OUT1=%h, D_OUT2=%h, D_OUT3=%h",
                         D_OUT1, D_OUT2, D_OUT3);
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
        $dumpvars(0,ADDR_IN1, ADDR_IN2, ADDR_OUT1, ADDR_OUT2, ADDR_OUT3, CLK, D_IN1, D_IN2, WE1, WE2, rst_n, D_OUT1, D_OUT2, D_OUT3);
    end

endmodule
