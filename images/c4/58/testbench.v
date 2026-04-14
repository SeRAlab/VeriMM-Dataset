`timescale 1ns/1ps

module cantidadecho_tb;

    // Testbench signals (sequential circuit)
    reg CLKOUT;
    reg [7:0] cantidad;
    reg entrada;
    reg reset;
    wire ECHO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cantidadecho dut (
        .CLKOUT(CLKOUT),
        .cantidad(cantidad),
        .entrada(entrada),
        .reset(reset),
        .ECHO(ECHO)
    );

    // Clock generation (10ns period)
    initial begin
        CLKOUT = 0;
        forever #5 CLKOUT = ~CLKOUT;
    end

        task reset_dut;

        begin
            reset = 1;
            entrada = 0;
            cantidad = 8'd10;
            @(posedge CLKOUT);
            #2 reset = 0;
            @(posedge CLKOUT);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Trigger pulse start", test_num);
            reset_dut();
            @(posedge CLKOUT);
            entrada = 1;
            @(posedge CLKOUT);
            entrada = 0;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Pulse duration check (Cycle 10)", test_num);
            reset_dut();
            @(posedge CLKOUT);
            entrada = 1;
            @(posedge CLKOUT);
            entrada = 0;

            repeat(9) @(posedge CLKOUT);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Pulse termination check (Cycle 11)", test_num);
            reset_dut();
            @(posedge CLKOUT);
            entrada = 1;
            @(posedge CLKOUT);
            entrada = 0;

            repeat(10) @(posedge CLKOUT);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Single pulse trigger robustness", test_num);
            reset_dut();
            @(posedge CLKOUT);
            entrada = 1;
            #2;
            entrada = 0;

            repeat(5) @(posedge CLKOUT);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset during active pulse", test_num);
            reset_dut();
            @(posedge CLKOUT);
            entrada = 1;
            @(posedge CLKOUT);
            entrada = 0;
            repeat(3) @(posedge CLKOUT);
            reset = 1;
            #10;
            reset = 0;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cantidadecho Testbench");
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
        input expected_ECHO;
        begin
            if (expected_ECHO === (expected_ECHO ^ ECHO ^ expected_ECHO)) begin
                $display("PASS");
                $display("  Outputs: ECHO=%b",
                         ECHO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ECHO=%b",
                         expected_ECHO);
                $display("  Got:      ECHO=%b",
                         ECHO);
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
        $dumpvars(0,CLKOUT, cantidad, entrada, reset, ECHO);
    end

endmodule
