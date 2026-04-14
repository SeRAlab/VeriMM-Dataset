`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    reg serial_in;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .serial_in(serial_in),
        .q(q)
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
            enable = 0;
            serial_in = 0;
            @(posedge clk);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Reset", test_num);
            reset_dut();

            enable = 1;
            serial_in = 1;
            repeat (5) @(posedge clk);

            reset = 1;
            @(posedge clk);
            reset = 0;
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit shift in", test_num);
            reset_dut();
            enable = 1;
            serial_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple shifts (4 bits)", test_num);
            reset_dut();
            enable = 1;
            serial_in = 1;
            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable signal gating", test_num);
            reset_dut();

            enable = 1;
            serial_in = 1;
            @(posedge clk);

            enable = 0;
            serial_in = 1;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase005;

        integer i;
        reg [15:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in 16-bit pattern 0xAAAA", test_num);
            reset_dut();
            pattern = 16'hAAAA;
            enable = 1;



            for (i = 15; i >= 0; i = i - 1) begin
                serial_in = pattern[i];
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset priority over enable", test_num);
            reset_dut();
            enable = 1;
            serial_in = 1;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MSB Overflow check", test_num);
            reset_dut();
            enable = 1;

            serial_in = 1;
            @(posedge clk);
            serial_in = 0;
            repeat (15) @(posedge clk);

            #1;
            if (q == 16'h8000) begin

                @(posedge clk);
                #1;
                #1;

                check_outputs(16'h0000);
            end else begin
                #1;

                check_outputs(16'h8000);
            end
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
        input [15:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, enable, reset, serial_in, q);
    end

endmodule
