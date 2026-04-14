`timescale 1ns/1ps

module PISO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallel_in;
    reg shift_enable;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PISO_Shift_Register dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .shift_enable(shift_enable),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 0;
            shift_enable = 0;
            parallel_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 8'b10110001 and check MSB", test_num);
            reset_dut();
            parallel_in = 8'b10110001;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 8'hA5 (10100101) and shift 7 times to LSB", test_num);
            reset_dut();
            parallel_in = 8'hA5;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift_enable = 1;
            repeat (7) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 8'h5A (01011010) and shift 7 times to LSB", test_num);
            reset_dut();
            parallel_in = 8'h5A;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift_enable = 1;
            repeat (7) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load and verify shift_enable = 0 holds data", test_num);
            reset_dut();
            parallel_in = 8'b11001100;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift_enable = 0;
            repeat (4) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 8'h00 and shift", test_num);
            reset_dut();
            parallel_in = 8'h00;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift_enable = 1;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 8'b11110000 and shift 4 times", test_num);
            reset_dut();
            parallel_in = 8'b11110000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift_enable = 1;
            repeat (4) @(posedge clk);
            #1;

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
        $display("PISO_Shift_Register Testbench");
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
        $dumpvars(0,clk, load, parallel_in, shift_enable, serial_out);
    end

endmodule
