`timescale 1ns/1ps

module eeprom_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg read_enable;
    reg write_enable;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_cell dut (
        .clk(clk),
        .data_in(data_in),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 0;
            write_enable = 1;
            read_enable = 0;
            @(posedge clk);
            #1;
            write_enable = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Write 1 and Read 1");
            reset_dut();


            data_in = 1;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_enable = 1;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Write 0 and Read 0");
            reset_dut();


            data_in = 1;
            write_enable = 1;
            @(posedge clk);
            #1;


            data_in = 0;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_enable = 1;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Data Retention (no write when write_enable is low)");
            reset_dut();


            data_in = 1;
            write_enable = 1;
            @(posedge clk);
            #1;


            write_enable = 0;
            data_in = 0;
            @(posedge clk);
            @(posedge clk);
            #1;


            read_enable = 1;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Read Enable functionality (output should be 0 or Z when low)");
            reset_dut();


            data_in = 1;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_enable = 0;
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Stability over multiple clock cycles");
            reset_dut();


            data_in = 1;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;


            repeat(5) @(posedge clk);


            read_enable = 1;
            #2;
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
        $display("eeprom_cell Testbench");
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
        $dumpvars(0,clk, data_in, read_enable, write_enable, data_out);
    end

endmodule
