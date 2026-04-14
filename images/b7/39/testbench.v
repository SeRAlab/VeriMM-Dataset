`timescale 1ns/1ps

module piso_shift_register_6bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [5:0] parallel_in;
    reg rst;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    piso_shift_register_6bit dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .rst(rst),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            parallel_in = 6'b0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Synchronous Reset Check", test_num);
            reset_dut();


            load = 1;
            parallel_in = 6'b111111;
            @(posedge clk);
            #1 load = 0;


            rst = 1;
            @(posedge clk);
            #1 rst = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Load and Check LSB", test_num);
            reset_dut();

            load = 1;
            parallel_in = 6'b101011;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Shift MSB to Serial Out", test_num);
            reset_dut();


            load = 1;
            parallel_in = 6'b100000;
            @(posedge clk);
            #1 load = 0;


            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Shift middle bit to output", test_num);
            reset_dut();

            load = 1;
            parallel_in = 6'b001000;
            @(posedge clk);
            #1 load = 0;


            repeat (3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Full Shift Out Check", test_num);
            reset_dut();

            load = 1;
            parallel_in = 6'b111111;
            @(posedge clk);
            #1 load = 0;


            repeat (6) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Alternating pattern shift", test_num);
            reset_dut();

            load = 1;
            parallel_in = 6'b010101;
            @(posedge clk);
            #1 load = 0;

            repeat (2) @(posedge clk);
            #1;

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
        $display("piso_shift_register_6bit Testbench");
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
        $dumpvars(0,clk, load, parallel_in, rst, serial_out);
    end

endmodule
