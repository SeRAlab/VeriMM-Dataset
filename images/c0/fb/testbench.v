`timescale 1ns/1ps

module RAM1Kx1_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] AB1;
    reg [9:0] AB2;
    reg CLK1;
    reg CLK2;
    reg CS1;
    reg CS2;
    reg DI1;
    reg READ;
    wire DO1;
    wire DO2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RAM1Kx1 dut (
        .AB1(AB1),
        .AB2(AB2),
        .CLK1(CLK1),
        .CLK2(CLK2),
        .CS1(CS1),
        .CS2(CS2),
        .DI1(DI1),
        .READ(READ),
        .DO1(DO1),
        .DO2(DO2)
    );

    // Clock generation (10ns period)
    initial begin
        CLK1 = 0;
        forever #5 CLK1 = ~CLK1;
    end

        task reset_dut;

        begin
            AB1 = 10'd0;
            AB2 = 10'd0;
            CS1 = 1'b0;
            CS2 = 1'b0;
            DI1 = 1'b0;
            READ = 1'b1;
            @(posedge CLK1);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Initial FILL Read");
            CS1 = 1'b1; READ = 1'b1; AB1 = 10'd0;
            CS2 = 1'b1; AB2 = 10'd1;
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Port 1 Write/Read");

            CS1 = 1'b1; READ = 1'b0; AB1 = 10'd512; DI1 = 1'b1;
            @(posedge CLK1); #1;

            READ = 1'b1;
            #1;
            #1;

            check_outputs(1'b1, 1'bz);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Port 1 Write, Port 2 Read");

            CS1 = 1'b1; READ = 1'b0; AB1 = 10'd700; DI1 = 1'b0;
            @(posedge CLK1); #1;

            CS2 = 1'b1; AB2 = 10'd700;
            READ = 1'b1; AB1 = 10'd0;
            #1;
            #1;

            check_outputs(1'bz, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: High-Z on CS disable");
            CS1 = 1'b0; CS2 = 1'b0;
            #1;
            #1;

            check_outputs(1'bz, 1'bz);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Simultaneous Write and Read different addresses");
            CS1 = 1'b1; READ = 1'b0; AB1 = 10'd100; DI1 = 1'b1;
            CS2 = 1'b1; AB2 = 10'd200;
            @(posedge CLK1); #1;

            #1;


            check_outputs(1'bz, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Write Overwrite Check");

            CS1 = 1'b1; READ = 1'b0; AB1 = 10'd800; DI1 = 1'b1;
            @(posedge CLK1); #1;

            DI1 = 1'b0;
            @(posedge CLK1); #1;

            READ = 1'b1;
            #1;
            #1;

            check_outputs(1'b0, 1'bz);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RAM1Kx1 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_DO1;
        input expected_DO2;
        begin
            if (expected_DO1 === (expected_DO1 ^ DO1 ^ expected_DO1) &&
                expected_DO2 === (expected_DO2 ^ DO2 ^ expected_DO2)) begin
                $display("PASS");
                $display("  Outputs: DO1=%b, DO2=%b",
                         DO1, DO2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DO1=%b, DO2=%b",
                         expected_DO1, expected_DO2);
                $display("  Got:      DO1=%b, DO2=%b",
                         DO1, DO2);
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
        $dumpvars(0,AB1, AB2, CLK1, CLK2, CS1, CS2, DI1, READ, DO1, DO2);
    end

endmodule
