`timescale 1ns/1ps

module piso_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallel_in;
    reg reset;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    piso_shift_register dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .reset(reset),
        .serial_out(serial_out)
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
            load = 0;
            parallel_in = 8'b0;
            @(posedge clk);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            parallel_in = 8'b10110010;
            load = 1;
            @(posedge clk);
            load = 0;
            #1;
            $display("Testcase 001: Checking MSB after load...");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            parallel_in = 8'b10110010;
            load = 1;
            @(posedge clk);
            load = 0;
            @(posedge clk);
            #1;
            $display("Testcase 002: Checking bit after 1 shift...");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            parallel_in = 8'b10110011;
            load = 1;
            @(posedge clk);
            load = 0;
            repeat(7) @(posedge clk);
            #1;
            $display("Testcase 003: Checking LSB after 7 shifts...");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            parallel_in = 8'hFF;
            load = 1;
            @(posedge clk);
            load = 0;
            repeat(2) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            #1;
            $display("Testcase 004: Verifying synchronous reset clears output...");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            parallel_in = 8'b11001100;
            load = 1;
            @(posedge clk);
            load = 0;
            parallel_in = 8'b00000000;
            repeat(4) @(posedge clk);
            #1;
            $display("Testcase 005: Verifying parallel_in is ignored while load=0...");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            parallel_in = 8'h00;
            load = 1;
            @(posedge clk);
            load = 0;
            repeat(7) @(posedge clk);
            #1;
            $display("Testcase 006: Verifying all zeros...");
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
        $display("piso_shift_register Testbench");
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
        $dumpvars(0,clk, load, parallel_in, reset, serial_out);
    end

endmodule
