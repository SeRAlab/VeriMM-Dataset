`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg re;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .clk(clk),
        .data_in(data_in),
        .re(re),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            re = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Basic Write and Read", test_num);


            we = 1;
            data_in = 8'hAA;
            @(posedge clk);
            #1;
            we = 0;


            re = 1;
            #2;
            #1;

            check_outputs(8'hAA);
            re = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Overwriting data", test_num);


            we = 1;
            data_in = 8'h55;
            @(posedge clk);
            #1;


            data_in = 8'h33;
            @(posedge clk);
            #1;
            we = 0;


            re = 1;
            #2;
            #1;

            check_outputs(8'h33);
            re = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Read Enable inactive check", test_num);


            we = 1;
            data_in = 8'hFF;
            @(posedge clk);
            #1;
            we = 0;


            re = 0;
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Write Enable inactive check", test_num);


            we = 0;
            data_in = 8'hCC;
            @(posedge clk);
            #1;


            re = 1;
            #2;
            #1;

            check_outputs(8'h00);
            re = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Data persistence check", test_num);


            we = 1;
            data_in = 8'h12;
            @(posedge clk);
            #1;
            we = 0;


            repeat(3) @(posedge clk);
            #1;


            re = 1;
            #2;
            #1;

            check_outputs(8'h12);
            re = 0;
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
        $dumpvars(0,clk, data_in, re, we, data_out);
    end

endmodule
