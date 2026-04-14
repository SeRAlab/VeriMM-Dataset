`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load_en;
    reg [7:0] parallel_in;
    reg shift_en;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .load_en(load_en),
        .parallel_in(parallel_in),
        .shift_en(shift_en),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            load_en = 0;
            shift_en = 0;
            parallel_in = 8'h00;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Parallel Load", test_num);
            reset_dut();

            load_en = 1;
            parallel_in = 8'hAB;
            @(posedge clk);
            #1;
            load_en = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift Right Once", test_num);
            reset_dut();


            load_en = 1;
            parallel_in = 8'h02;
            @(posedge clk);
            #1;


            load_en = 0;
            shift_en = 1;
            @(posedge clk);
            #1;
            shift_en = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full Shift Sequence", test_num);
            reset_dut();


            load_en = 1;
            parallel_in = 8'h80;
            @(posedge clk);
            #1;
            load_en = 0;


            shift_en = 1;
            for (i = 0; i < 7; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            shift_en = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority Check (Load vs Shift)", test_num);
            reset_dut();

            load_en = 1;
            shift_en = 1;
            parallel_in = 8'hAA;
            @(posedge clk);
            #1;
            load_en = 0;
            shift_en = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift beyond data", test_num);
            reset_dut();

            load_en = 1;
            parallel_in = 8'h01;
            @(posedge clk);
            #1;
            load_en = 0;

            shift_en = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            shift_en = 0;

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
        input expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, load_en, parallel_in, shift_en, serial_out);
    end

endmodule
