`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ADDR;
    reg CLK;
    reg DI;
    reg EN;
    reg WE;
    wire DO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR(ADDR),
        .CLK(CLK),
        .DI(DI),
        .EN(EN),
        .WE(WE),
        .DO(DO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            EN = 0;
            WE = 0;
            ADDR = 0;
            DI = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read");
            reset_dut();


            EN = 1;
            WE = 1;
            ADDR = 4'h3;
            DI = 8'hA5;
            @(posedge CLK);
            #1;


            WE = 0;
            ADDR = 4'h3;
            @(posedge CLK);
            #1;



            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Enable Signal Logic (Write Disabled)");
            reset_dut();


            EN = 0;
            WE = 1;
            ADDR = 4'h5;
            DI = 8'hFF;
            @(posedge CLK);
            #1;


            EN = 1;
            WE = 0;
            ADDR = 4'h5;
            @(posedge CLK);
            #1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Memory Overwrite");
            reset_dut();


            EN = 1; WE = 1; ADDR = 4'hA; DI = 8'h11;
            @(posedge CLK); #1;


            DI = 8'h22;
            @(posedge CLK); #1;


            WE = 0;
            @(posedge CLK); #1;
            @(posedge CLK); #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Successive Reads");
            reset_dut();


            EN = 1; WE = 1; ADDR = 4'h1; DI = 8'hCC; @(posedge CLK); #1;
            EN = 1; WE = 1; ADDR = 4'h2; DI = 8'hDD; @(posedge CLK); #1;


            WE = 0; ADDR = 4'h1; @(posedge CLK); #1;
            ADDR = 4'h2; @(posedge CLK); #1;


            #1;



            check_outputs(8'hCC);


            @(posedge CLK); #1;
            #1;

            check_outputs(8'hDD);
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
        input expected_DO;
        begin
            if (expected_DO === (expected_DO ^ DO ^ expected_DO)) begin
                $display("PASS");
                $display("  Outputs: DO=%b",
                         DO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DO=%b",
                         expected_DO);
                $display("  Got:      DO=%b",
                         DO);
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
        $dumpvars(0,ADDR, CLK, DI, EN, WE, DO);
    end

endmodule
