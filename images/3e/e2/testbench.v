`timescale 1ns/1ps

module pipo_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg load;
    reg reset;
    wire [4:0] data_out;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipo_shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .data_out(data_out),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            data_in = 5'b0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(5'b00000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            data_in = 5'b11011;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b11011, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            data_in = 5'b10110;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'b01011, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            data_in = 5'b10000;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(5'b00001, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            data_in = 5'b00001;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'b00000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            data_in = 5'b11111;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(5'b00111, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipo_shift_register Testbench");
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
        input [4:0] expected_data_out;
        input expected_serial_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, serial_out=%b",
                         data_out, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, serial_out=%b",
                         expected_data_out, expected_serial_out);
                $display("  Got:      data_out=%h, serial_out=%b",
                         data_out, serial_out);
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
        $dumpvars(0,clk, data_in, load, reset, data_out, serial_out);
    end

endmodule
