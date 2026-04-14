`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] data_in;
    reg shift;
    wire [1:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .shift(shift),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            shift = 0;
            data_in = 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Parallel Load 2'b10");
            reset_dut();
            test_num = 1;
            shift = 0;
            data_in = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Parallel Load 2'b01");
            reset_dut();
            test_num = 2;
            shift = 0;
            data_in = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift Right (Load 10, shift in 1)");
            reset_dut();
            test_num = 3;

            shift = 0;
            data_in = 2'b10;
            @(posedge clk);



            shift = 1;
            data_in = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Shift Right (Load 11, shift in 0)");
            reset_dut();
            test_num = 4;

            shift = 0;
            data_in = 2'b11;
            @(posedge clk);

            shift = 1;
            data_in = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Double Shift Right (Load 11, shift in 0 twice)");
            reset_dut();
            test_num = 5;

            shift = 0;
            data_in = 2'b11;
            @(posedge clk);

            shift = 1;
            data_in = 2'b00;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Multi-bit Shift Sequence (Load 00, shift 1, then shift 0)");
            reset_dut();
            test_num = 6;

            shift = 0;
            data_in = 2'b00;
            @(posedge clk);

            shift = 1;
            data_in = 2'b01;
            @(posedge clk);

            data_in = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
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
        input [1:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, shift, data_out);
    end

endmodule
