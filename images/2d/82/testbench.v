`timescale 1ns/1ps

module SRAM_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] address;
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
    SRAM dut (
        .address(address),
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
            address = 3'b0;
            data_in = 8'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read", test_num);


            @(posedge clk);
            address = 3'd0;
            data_in = 8'hA5;
            we = 1;
            @(posedge clk);
            we = 0;


            @(posedge clk);
            address = 3'd0;
            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
            re = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Write/Read at Address 7", test_num);


            @(posedge clk);
            address = 3'd7;
            data_in = 8'h5A;
            we = 1;
            @(posedge clk);
            we = 0;


            @(posedge clk);
            address = 3'd7;
            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A);
            re = 0;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Data Overwrite", test_num);


            @(posedge clk);
            address = 3'd4;
            data_in = 8'hFF;
            we = 1;
            @(posedge clk);


            data_in = 8'h33;
            @(posedge clk);
            we = 0;


            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h33);
            re = 0;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Address Isolation", test_num);


            @(posedge clk);
            address = 3'd1;
            data_in = 8'h11;
            we = 1;
            @(posedge clk);


            address = 3'd2;
            data_in = 8'h22;
            @(posedge clk);
            we = 0;


            address = 3'd1;
            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h11);
            re = 0;
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Zero Value Write", test_num);


            @(posedge clk);
            address = 3'd5;
            data_in = 8'h00;
            we = 1;
            @(posedge clk);
            we = 0;


            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
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
        $display("SRAM Testbench");
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
        $dumpvars(0,address, clk, data_in, re, we, data_out);
    end

endmodule
