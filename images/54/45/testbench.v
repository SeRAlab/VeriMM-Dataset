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
            @(negedge CLK);
            EN = 0;
            WE = 0;
            ADDR = 0;
            DI = 0;
            @(negedge CLK);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            @(negedge CLK);
            EN = 1; WE = 1; ADDR = 4'h4; DI = 8'hA5;
            @(negedge CLK);

            EN = 1; WE = 0; ADDR = 4'h4;
            @(posedge CLK);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            @(negedge CLK);
            EN = 1; WE = 1; ADDR = 4'h1; DI = 8'h11;
            @(negedge CLK);

            EN = 1; WE = 1; ADDR = 4'h1; DI = 8'h22;
            @(negedge CLK);

            EN = 1; WE = 0; ADDR = 4'h1;
            @(posedge CLK);
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            @(negedge CLK);
            EN = 1; WE = 1; ADDR = 4'h3; DI = 8'h33;
            @(negedge CLK);

            EN = 0; WE = 1; ADDR = 4'h3; DI = 8'hFF;
            @(negedge CLK);

            EN = 1; WE = 0; ADDR = 4'h3;
            @(posedge CLK);
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            @(negedge CLK);
            EN = 1; WE = 1; ADDR = 4'h5; DI = 8'h55;
            @(negedge CLK);

            EN = 1; WE = 0; ADDR = 4'h5; DI = 8'hEE;
            @(negedge CLK);

            EN = 1; WE = 0; ADDR = 4'h5;
            @(posedge CLK);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            @(negedge CLK);
            EN = 1; WE = 1; ADDR = 4'hF; DI = 8'h99;
            @(negedge CLK);

            EN = 1; WE = 1; ADDR = 4'h0; DI = 8'h66;
            @(negedge CLK);

            EN = 1; WE = 0; ADDR = 4'h0;
            @(posedge CLK);
            #1;

            check_outputs(8'h66);
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
