`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] a;
    reg c;
    reg w;
    reg [31:0] wd;
    wire [31:0] rd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .c(c),
        .w(w),
        .wd(wd),
        .rd(rd)
    );

    // Clock generation (10ns period)
    initial begin
        c = 0;
        forever #5 c = ~c;
    end

        task reset_dut;

        begin
            a = 0;
            w = 0;
            wd = 0;
            uart_drive = 1'bz;
            repeat (10) @(posedge c);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            @(posedge c);
            a = 2'b00;
            w = 1;
            wd = 32'hDEADBEEF;
            @(posedge c);
            w = 0;


            @(posedge c);
            a = 2'b00;
            repeat (2) @(posedge c);

            $display("Testcase 001: Write/Read Data Buffer");
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(posedge c);
            a = 2'b01;
            w = 1;
            wd = 32'h00000001;
            @(posedge c);
            w = 0;


            @(posedge c);
            a = 2'b01;
            repeat (2) @(posedge c);

            $display("Testcase 002: Status/Config Register Read");
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(posedge c);
            a = 2'b00;
            w = 1;
            wd = 32'h55AA55AA;
            @(posedge c);
            w = 0;

            @(posedge c);
            a = 2'b00;
            repeat (2) @(posedge c);

            $display("Testcase 003: Bit Pattern 0x55AA55AA Verification");
            #1;

            check_outputs(32'h55AA55AA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            @(posedge c);
            a = 2'b00; w = 1; wd = 32'h11111111;
            @(posedge c);

            wd = 32'h22222222;
            @(posedge c);
            w = 0;

            @(posedge c);
            a = 2'b00;
            repeat (2) @(posedge c);

            $display("Testcase 004: Overwrite/Consecutive Write Check");
            #1;

            check_outputs(32'h22222222);
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
        input [31:0] expected_rd;
        begin
            if (expected_rd === (expected_rd ^ rd ^ expected_rd)) begin
                $display("PASS");
                $display("  Outputs: rd=%h",
                         rd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd=%h",
                         expected_rd);
                $display("  Got:      rd=%h",
                         rd);
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
        $dumpvars(0,a, c, w, wd, rd);
    end

endmodule
