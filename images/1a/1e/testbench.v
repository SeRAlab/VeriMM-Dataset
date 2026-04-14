`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data_in;
    reg read_enable;
    reg write_enable;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
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
            write_enable = 0;
            data_in = 4'b0000;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Writing and Reading 4'hA", test_num);


            write_enable = 1;
            data_in = 4'hA;
            #10;
            write_enable = 0;


            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Writing and Reading 4'h5", test_num);

            write_enable = 1;
            data_in = 4'h5;
            #10;
            write_enable = 0;

            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Verify Write Enable (Attempt write with WE=0)", test_num);


            write_enable = 1;
            data_in = 4'hF;
            #10;


            write_enable = 0;
            data_in = 4'h0;
            #10;


            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Write and Read All Ones", test_num);

            write_enable = 1;
            data_in = 4'hF;
            #10;
            write_enable = 0;

            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Write and Read All Zeros", test_num);

            write_enable = 1;
            data_in = 4'h0;
            #10;
            write_enable = 0;

            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: Data Persistence Over Multiple Cycles", test_num);


            write_enable = 1;
            data_in = 4'hC;
            #10;
            write_enable = 0;


            #30;

            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(4'hC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_Cell Testbench");
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,data_in, read_enable, write_enable, data_out);
    end

endmodule
