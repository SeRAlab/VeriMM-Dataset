`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg data_in;
    reg sense_line;
    reg word_line;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .data_in(data_in),
        .sense_line(sense_line),
        .word_line(word_line),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        sense_line = 0;
        forever #5 sense_line = ~sense_line;
    end

        task reset_dut;

        begin
            word_line = 1;
            data_in = 0;
            #10;
            word_line = 0;
            data_in = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Write 1 and Read 1");
            test_num = test_num + 1;
            reset_dut();


            word_line = 1;
            data_in = 1;
            #10;
            word_line = 0;


            wait(sense_line == 1);
            #2;
            #1;

            check_outputs(1'b1);
            #8;
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write 0 and Read 0");
            test_num = test_num + 1;
            reset_dut();


            word_line = 1;
            data_in = 0;
            #10;
            word_line = 0;


            wait(sense_line == 1);
            #2;
            #1;

            check_outputs(1'b0);
            #8;
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Data Retention Check (High)");
            test_num = test_num + 1;
            reset_dut();


            word_line = 1;
            data_in = 1;
            #10;


            word_line = 0;
            data_in = 0;
            #20;


            wait(sense_line == 1);
            #2;
            #1;

            check_outputs(1'b1);
            #8;
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Data Retention Check (Low)");
            test_num = test_num + 1;
            reset_dut();


            word_line = 1;
            data_in = 0;
            #10;


            word_line = 0;
            data_in = 1;
            #20;


            wait(sense_line == 1);
            #2;
            #1;

            check_outputs(1'b0);
            #8;
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Consecutive Write Update");
            test_num = test_num + 1;
            reset_dut();


            word_line = 1;
            data_in = 1;
            #10;


            word_line = 1;
            data_in = 0;
            #10;
            word_line = 0;


            wait(sense_line == 1);
            #2;
            #1;

            check_outputs(1'b0);
            #8;
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
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
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
        $dumpvars(0,data_in, sense_line, word_line, data_out);
    end

endmodule
