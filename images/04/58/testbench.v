`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load_en;
    reg [7:0] parallel_in;
    reg serial_in;
    wire [7:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .load_en(load_en),
        .parallel_in(parallel_in),
        .serial_in(serial_in),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load_en = 1;
            parallel_in = 8'h00;
            serial_in = 0;
            @(posedge clk);
            #1;
            load_en = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Parallel Load 0xA5", test_num);
            reset_dut();
            load_en = 1;
            parallel_in = 8'hA5;
            @(posedge clk);
            #1;
            load_en = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load 0xFF and Shift Right once with serial_in=0", test_num);
            reset_dut();

            load_en = 1;
            parallel_in = 8'hFF;
            @(posedge clk);
            #1;

            load_en = 0;
            serial_in = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h7F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Right 8 times with serial_in=1", test_num);
            reset_dut();
            load_en = 0;
            serial_in = 1;
            repeat(8) @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load 0x80 and shift right 7 times", test_num);
            reset_dut();

            load_en = 1;
            parallel_in = 8'h80;
            @(posedge clk);
            #1;

            load_en = 0;
            serial_in = 0;
            repeat(7) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift in pattern 1011", test_num);
            reset_dut();
            load_en = 0;

            serial_in = 1; @(posedge clk);
            serial_in = 0; @(posedge clk);
            serial_in = 1; @(posedge clk);
            serial_in = 1; @(posedge clk);
            #1;

            #1;


            check_outputs(8'hD0);
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
        input [7:0] expected_parallel_out;
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
        $dumpvars(0,clk, load_en, parallel_in, serial_in, parallel_out);
    end

endmodule
