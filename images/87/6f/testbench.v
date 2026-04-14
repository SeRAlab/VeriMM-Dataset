`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [15:0] IN;
    reg LOAD;
    wire [15:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .IN(IN),
        .LOAD(LOAD),
        .OUT(OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            LOAD = 1;
            IN = 16'h0000;
            @(posedge CLK);
            #1;
            LOAD = 0;
            IN = 16'h0000;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            LOAD = 1;
            IN = 16'hACE0;
            @(posedge CLK);
            #1;
            LOAD = 0;
            #1;

            check_outputs(16'hACE0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            LOAD = 1; IN = 16'h0001;
            @(posedge CLK);

            #1; LOAD = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();

            LOAD = 1; IN = 16'h000F;
            @(posedge CLK);

            #1; LOAD = 0;
            for(i = 0; i < 4; i = i + 1) begin
                @(posedge CLK);
            end
            #1;
            #1;

            check_outputs(16'h00F0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            LOAD = 1; IN = 16'h8001;
            @(posedge CLK);

            #1; LOAD = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();

            LOAD = 1; IN = 16'hFFFF;
            @(posedge CLK);

            #1; LOAD = 0;
            for(i = 0; i < 16; i = i + 1) begin
                @(posedge CLK);
            end
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            LOAD = 0;
            @(posedge CLK);
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_OUT;
        begin
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
        $dumpvars(0,CLK, IN, LOAD, OUT);
    end

endmodule
