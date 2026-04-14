`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg serial_in;
    reg shift_enable;
    wire [15:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .shift_enable(shift_enable),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            serial_in = 0;
            shift_enable = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Bit Shift Left", test_num);
            reset_dut();

            @(negedge clk);
            shift_enable = 1;
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
            $display("Testcase %0d: Multiple Bit Shift (3 bits)", test_num);
            reset_dut();

            @(negedge clk);
            shift_enable = 1;


            serial_in = 1;
            @(posedge clk);


            @(negedge clk);
            serial_in = 0;
            @(posedge clk);


            @(negedge clk);
            serial_in = 1;
            @(posedge clk);

            #1;

            #1;


            check_outputs(16'h0005);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Enable Hold Check", test_num);
            reset_dut();


            @(negedge clk);
            shift_enable = 1;
            serial_in = 1;
            @(posedge clk);


            @(negedge clk);
            shift_enable = 0;
            serial_in = 1;

            repeat (5) @(posedge clk);

            #1;

            #1;


            check_outputs(16'h0001);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill Entire Register (0xFFFF)", test_num);
            reset_dut();

            @(negedge clk);
            shift_enable = 1;
            serial_in = 1;

            repeat (16) @(posedge clk);

            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        reg [15:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Pattern 0xACE1", test_num);
            reset_dut();

            pattern = 16'hACE1;
            @(negedge clk);
            shift_enable = 1;



            for (i = 15; i >= 0; i = i - 1) begin
                serial_in = pattern[i];
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(16'hACE1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Overflow Check", test_num);
            reset_dut();

            @(negedge clk);
            shift_enable = 1;
            serial_in = 1;


            repeat (16) @(posedge clk);


            @(negedge clk);
            serial_in = 0;
            @(posedge clk);

            #1;

            #1;


            check_outputs(16'hFFFE);
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
        input [15:0] expected_parallel_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h",
                         parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h",
                         expected_parallel_out);
                $display("  Got:      parallel_out=%h",
                         parallel_out);
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
        $dumpvars(0,clk, reset, serial_in, shift_enable, parallel_out);
    end

endmodule
