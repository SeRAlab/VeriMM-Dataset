`timescale 1ns/1ps

module pulse_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg start;
    reg [3:0] width;
    wire pulse_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pulse_generator dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .width(width),
        .pulse_out(pulse_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            width = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Width = 4 cycles", test_num);
            reset_dut();

            width = 4;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            repeat(4) @(posedge clk);


            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Width = 15 cycles", test_num);
            reset_dut();

            width = 15;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat(15) @(posedge clk);

            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Min Width = 1 cycle", test_num);
            reset_dut();

            width = 1;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat(1) @(posedge clk);

            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Width = 0 cycles", test_num);
            reset_dut();

            width = 0;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat(2) @(posedge clk);

            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sustained Start Signal (Width = 5)", test_num);
            reset_dut();

            width = 5;
            @(posedge clk);
            #1 start = 1;

            repeat(6) @(posedge clk);

            #1 #1;
 check_outputs(1'b0);
            start = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pulse_generator Testbench");
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
        input expected_pulse_out;
        begin
            if (expected_pulse_out === (expected_pulse_out ^ pulse_out ^ expected_pulse_out)) begin
                $display("PASS");
                $display("  Outputs: pulse_out=%b",
                         pulse_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pulse_out=%b",
                         expected_pulse_out);
                $display("  Got:      pulse_out=%b",
                         pulse_out);
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
        $dumpvars(0,clk, rst, start, width, pulse_out);
    end

endmodule
