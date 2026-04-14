`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg data_in;
    reg refresh;
    reg write_enable;
    wire data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .data_in(data_in),
        .refresh(refresh),
        .write_enable(write_enable),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        refresh = 0;
        forever #5 refresh = ~refresh;
    end

        task reset_dut;

        begin
            write_enable = 0;
            data_in = 0;

            repeat (2) @(posedge refresh);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Writing 1...");
            reset_dut();
            @(posedge refresh);
            write_enable = 1;
            data_in = 1;
            @(posedge refresh);
            write_enable = 0;
            data_in = 0;
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Writing 0...");
            reset_dut();
            @(posedge refresh);
            write_enable = 1;
            data_in = 0;
            @(posedge refresh);
            write_enable = 0;
            data_in = 1;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Testing data retention of '1'...");
            reset_dut();
            @(posedge refresh);
            write_enable = 1;
            data_in = 1;
            @(posedge refresh);
            write_enable = 0;
            data_in = 0;

            repeat (10) @(posedge refresh);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Overwriting '1' with '0'...");
            reset_dut();

            @(posedge refresh);
            write_enable = 1;
            data_in = 1;
            @(posedge refresh);

            data_in = 0;
            @(posedge refresh);
            write_enable = 0;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Data stability while write_enable is low...");
            reset_dut();

            @(posedge refresh);
            write_enable = 1;
            data_in = 0;
            @(posedge refresh);
            write_enable = 0;

            repeat (5) begin
                data_in = ~data_in;
                @(posedge refresh);
            end
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input expected_data_out;
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%b, valid=%b",
                         data_out, valid);
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
        $dumpvars(0,data_in, refresh, write_enable, data_out, valid);
    end

endmodule
