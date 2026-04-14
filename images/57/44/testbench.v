`timescale 1ns/1ps

module piso_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg LD;
    reg [7:0] Parallel_in;
    reg RST;
    wire Serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    piso_shift_register dut (
        .CLK(CLK),
        .LD(LD),
        .Parallel_in(Parallel_in),
        .RST(RST),
        .Serial_out(Serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            LD = 0;
            Parallel_in = 8'b0;
            #10;
            RST = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Load 8'b10101011 and check immediate LSB");
            reset_dut();
            @(posedge CLK);
            LD = 1;
            Parallel_in = 8'b10101011;
            @(posedge CLK);
            LD = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load 8'b00001000 and shift 3 times to check bit 3");
            reset_dut();
            @(posedge CLK);
            LD = 1;
            Parallel_in = 8'b00001000;
            @(posedge CLK);
            LD = 0;
            repeat(3) @(posedge CLK);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Load 8'b10000000 and shift 7 times to check bit 7");
            reset_dut();
            @(posedge CLK);
            LD = 1;
            Parallel_in = 8'b10000000;
            @(posedge CLK);
            LD = 0;
            repeat(7) @(posedge CLK);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Shift 8 times and verify trailing zeros");
            reset_dut();
            @(posedge CLK);
            LD = 1;
            Parallel_in = 8'b11111111;
            @(posedge CLK);
            LD = 0;
            repeat(8) @(posedge CLK);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Load data, shift, then reset and check output");
            reset_dut();
            @(posedge CLK);
            LD = 1;
            Parallel_in = 8'b11111111;
            @(posedge CLK);
            LD = 0;
            repeat(2) @(posedge CLK);
            RST = 1;
            #5;
            #1;

            check_outputs(1'b0);
            RST = 0;
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Load 8'b10101010 and check bit 1 after 1 shift");
            reset_dut();
            @(posedge CLK);
            LD = 1;
            Parallel_in = 8'b10101010;
            @(posedge CLK);
            LD = 0;
            repeat(1) @(posedge CLK);

            #1;


            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("piso_shift_register Testbench");
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
        input expected_Serial_out;
        begin
            if (expected_Serial_out === (expected_Serial_out ^ Serial_out ^ expected_Serial_out)) begin
                $display("PASS");
                $display("  Outputs: Serial_out=%b",
                         Serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Serial_out=%b",
                         expected_Serial_out);
                $display("  Got:      Serial_out=%b",
                         Serial_out);
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
        $dumpvars(0,CLK, LD, Parallel_in, RST, Serial_out);
    end

endmodule
