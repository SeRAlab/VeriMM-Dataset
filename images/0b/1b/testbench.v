`timescale 1ns/1ps

module sram_1bit_tb;

    // Testbench signals (sequential circuit)
    reg data_in;
    reg read_enable;
    reg write_enable;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_1bit dut (
        .data_in(data_in),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        read_enable = 0;
        forever #5 read_enable = ~read_enable;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            write_enable = 0;
            data_in = 0;

            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Writing 1 to SRAM and verifying output.");
            data_in = 1;
            write_enable = 1;
            #10;
            write_enable = 0;



            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Writing 0 to SRAM and verifying output.");

            data_in = 1;
            write_enable = 1;
            #10;

            data_in = 0;
            write_enable = 1;
            #10;
            write_enable = 0;

            #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Verify data retention when Write Enable is low.");

            data_in = 1;
            write_enable = 1;
            #10;
            write_enable = 0;


            data_in = 0;
            #10;

            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Successive write operations (0 -> 1 -> 0).");


            data_in = 1;
            write_enable = 1;
            #10;


            data_in = 0;
            write_enable = 1;
            #10;
            write_enable = 0;

            #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Verify data retention for value 0.");

            data_in = 0;
            write_enable = 1;
            #10;
            write_enable = 0;


            data_in = 1;
            #10;

            #5;
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
        $display("sram_1bit Testbench");
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
        $dumpvars(0,data_in, read_enable, write_enable, data_out);
    end

endmodule
