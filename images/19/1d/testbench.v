`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg re;
    reg rf;
    reg we;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .clk(clk),
        .data_in(data_in),
        .re(re),
        .rf(rf),
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
            test_num = test_num + 1;
            data_in = 4'b0;
            we = 0;
            re = 0;
            rf = 0;
            @(posedge clk);

            we = 1;
            data_in = 4'b0000;
            @(posedge clk);
            we = 0;
            data_in = 4'bzzzz;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Basic Write and Read");


            @(posedge clk);
            we = 1;
            data_in = 4'hA;

            @(posedge clk);
            we = 0;
            re = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Refresh protection during Write");


            @(posedge clk);
            we = 1;
            data_in = 4'h5;


            @(posedge clk);
            rf = 1;
            we = 1;
            data_in = 4'hF;

            @(posedge clk);
            rf = 0;
            we = 0;
            re = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Read Enable behavior");


            @(posedge clk);
            we = 1;
            data_in = 4'hC;


            @(posedge clk);
            we = 0;
            re = 0;

            @(posedge clk);
            #1;

            if (data_out !== 4'hC) begin
                $display("Information: data_out is %h when re=0", data_out);
            end


            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Data retention over time");


            @(posedge clk);
            we = 1;
            data_in = 4'h7;

            @(posedge clk);
            we = 0;
            data_in = 4'h0;


            repeat(5) @(posedge clk);

            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Overwriting data");


            @(posedge clk);
            we = 1;
            data_in = 4'h1;


            @(posedge clk);
            we = 1;
            data_in = 4'hE;

            @(posedge clk);
            we = 0;
            re = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hE);
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
        $dumpvars(0,clk, data_in, re, rf, we, data_out);
    end

endmodule
