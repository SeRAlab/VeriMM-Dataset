`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] in;
    reg shift_dir;
    reg shift_en;
    wire [7:0] out;
    wire [3:0] parallel_out;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .shift_dir(shift_dir),
        .shift_en(shift_en),
        .out(out),
        .parallel_out(parallel_out),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        shift_en = 0;
        forever #5 shift_en = ~shift_en;
    end

        task reset_dut;

        begin
            in = 8'h00;
            shift_dir = 0;
            repeat (8) @(negedge shift_en);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right Shift 8 bits", test_num);
            reset_dut();
            shift_dir = 0;

            in = 8'h80; @(negedge shift_en);
            in = 8'h00; @(negedge shift_en);
            in = 8'h80; @(negedge shift_en);
            in = 8'h80; @(negedge shift_en);
            in = 8'h00; @(negedge shift_en);
            in = 8'h00; @(negedge shift_en);
            in = 8'h80; @(negedge shift_en);
            in = 8'h80; @(negedge shift_en);



            #1;




            check_outputs(8'hCD, 4'hC, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left Shift 8 bits", test_num);
            reset_dut();
            shift_dir = 1;

            in = 8'h01; @(negedge shift_en);
            in = 8'h01; @(negedge shift_en);
            in = 8'h00; @(negedge shift_en);
            in = 8'h01; @(negedge shift_en);
            in = 8'h00; @(negedge shift_en);
            in = 8'h01; @(negedge shift_en);
            in = 8'h00; @(negedge shift_en);
            in = 8'h00; @(negedge shift_en);



            #1;




            check_outputs(8'hD4, 4'hD, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Partial Right Shift (4 bits)", test_num);
            reset_dut();
            shift_dir = 0;
            in = 8'h80;
            repeat (4) @(negedge shift_en);



            #1;




            check_outputs(8'hF0, 4'hF, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Left Shift", test_num);
            reset_dut();
            shift_dir = 1;
            repeat (4) begin
                in = 8'h01; @(negedge shift_en);
                in = 8'h00; @(negedge shift_en);
            end



            #1;




            check_outputs(8'hAA, 4'hA, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Direction Change", test_num);
            reset_dut();
            shift_dir = 0; in = 8'h80; repeat(4) @(negedge shift_en);
            shift_dir = 1; in = 8'h00; repeat(2) @(negedge shift_en);


            #1;



            check_outputs(8'hC0, 4'hC, 1'b1);
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
        input [7:0] expected_out;
        input [3:0] expected_parallel_out;
        input expected_serial_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h, parallel_out=%h, serial_out=%b",
                         out, parallel_out, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, parallel_out=%h, serial_out=%b",
                         expected_out, expected_parallel_out, expected_serial_out);
                $display("  Got:      out=%h, parallel_out=%h, serial_out=%b",
                         out, parallel_out, serial_out);
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
        $dumpvars(0,in, shift_dir, shift_en, out, parallel_out, serial_out);
    end

endmodule
