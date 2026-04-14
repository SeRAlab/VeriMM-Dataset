`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data_in;
    reg re;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .data_in(data_in),
        .re(re),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        re = 0;
        forever #5 re = ~re;
    end

        task reset_dut;

        begin
            we = 0;
            data_in = 8'h00;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read (0xAA)", test_num);
            reset_dut();


            we = 1;
            data_in = 8'hAA;
            #10;
            we = 0;


            wait(re == 1);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Write and Read (0x55)", test_num);
            reset_dut();


            we = 1;
            data_in = 8'h55;
            #10;
            we = 0;


            wait(re == 1);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Data Retention Test", test_num);
            reset_dut();


            we = 1;
            data_in = 8'hFF;
            #10;


            we = 0;
            data_in = 8'h00;
            #20;


            wait(re == 1);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Overwriting Data Test", test_num);
            reset_dut();


            we = 1;
            data_in = 8'h12;
            #10;


            data_in = 8'h34;
            #10;
            we = 0;


            wait(re == 1);
            #2;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Write Enable (we=0) Test", test_num);
            reset_dut();


            we = 1;
            data_in = 8'hBE;
            #10;


            we = 0;
            data_in = 8'hEF;
            #10;


            wait(re == 1);
            #2;
            #1;

            check_outputs(8'hBE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,data_in, re, we, data_out);
    end

endmodule
