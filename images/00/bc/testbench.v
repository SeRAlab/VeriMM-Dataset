`timescale 1ns/1ps

module SRAM_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    reg re;
    reg we;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_4bit dut (
        .clk(clk),
        .data(data),
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
            data = 4'h0;

            @(negedge clk);
            we = 1;
            data = 4'h0;
            @(negedge clk);
            we = 0;
            data = 4'h0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Basic Write and Read (4'hA)", test_num);


            @(negedge clk);
            we = 1;
            data = 4'hA;
            @(negedge clk);
            we = 0;


            re = 1;
            #2;
            #1;

            check_outputs(4'hA);
            re = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Basic Write and Read (4'h5)", test_num);


            @(negedge clk);
            we = 1;
            data = 4'h5;
            @(negedge clk);
            we = 0;


            re = 1;
            #2;
            #1;

            check_outputs(4'h5);
            re = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Verify Write Enable (we=0 prevents writing)", test_num);


            @(negedge clk);
            we = 1;
            data = 4'hF;
            @(negedge clk);


            we = 0;
            data = 4'h0;
            @(negedge clk);


            re = 1;
            #2;
            #1;

            check_outputs(4'hF);
            re = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Verify Read Enable (re=0 outputs 0)", test_num);


            @(negedge clk);
            we = 1;
            data = 4'hC;
            @(negedge clk);
            we = 0;


            re = 0;
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Boundary Value (4'hF)", test_num);

            @(negedge clk);
            we = 1;
            data = 4'hF;
            @(negedge clk);
            we = 0;

            re = 1;
            #2;
            #1;

            check_outputs(4'hF);
            re = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Sequential Writes", test_num);

            @(negedge clk);
            we = 1; data = 4'h1;
            @(negedge clk);
            data = 4'h2;
            @(negedge clk);
            data = 4'h3;
            @(negedge clk);
            we = 0;

            re = 1;
            #2;
            #1;

            check_outputs(4'h3);
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
        $display("SRAM_4bit Testbench");
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
        $dumpvars(0,clk, data, re, we, data_out);
    end

endmodule
