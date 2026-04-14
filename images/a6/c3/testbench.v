`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg serial_in;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            serial_in = 0;
            @(posedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in single '1'", test_num);
            reset_dut();
            @(posedge clk);
            serial_in = 1;
            @(posedge clk);
            serial_in = 0;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        reg [7:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in 8-bit pattern 0xAA", test_num);
            reset_dut();
            pattern = 8'hAA;
            for (i = 0; i < 8; i = i + 1) begin
                serial_in = pattern[7-i];
                @(posedge clk);
            end
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift 9 bits (0xFF then 0)", test_num);
            reset_dut();

            serial_in = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end

            serial_in = 0;
            @(posedge clk);

            #1;


            check_outputs(8'hFE);
        end
        endtask

    task testcase005;

        reg [7:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in 8-bit pattern 0x55", test_num);
            reset_dut();
            pattern = 8'h55;
            for (i = 0; i < 8; i = i + 1) begin
                serial_in = pattern[7-i];
                @(posedge clk);
            end
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset priority over shift", test_num);
            reset_dut();

            serial_in = 1;
            @(posedge clk);
            @(posedge clk);

            reset = 1;
            @(posedge clk);
            reset = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, reset, serial_in, out);
    end

endmodule
