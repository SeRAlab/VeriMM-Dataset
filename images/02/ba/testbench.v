`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d_in;
    reg re;
    reg we;
    wire [3:0] d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .clk(clk),
        .d_in(d_in),
        .re(re),
        .we(we),
        .d_out(d_out)
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
            d_in = 4'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read (4'hA)", test_num);
            reset_dut();


            @(negedge clk);
            we = 1;
            d_in = 4'hA;
            @(negedge clk);
            we = 0;


            re = 1;
            @(negedge clk);
            #1;

            check_outputs(4'hA);
            re = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data Persistence - WE=0 check", test_num);
            reset_dut();


            @(negedge clk);
            we = 1;
            d_in = 4'h5;
            @(negedge clk);


            we = 0;
            d_in = 4'hF;
            @(negedge clk);


            re = 1;
            @(negedge clk);
            #1;

            check_outputs(4'h5);
            re = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequential Writes (4'h1 -> 4'hE)", test_num);
            reset_dut();


            @(negedge clk);
            we = 1; d_in = 4'h1;
            @(negedge clk);


            we = 1; d_in = 4'hE;
            @(negedge clk);
            we = 0;


            re = 1;
            @(negedge clk);
            #1;

            check_outputs(4'hE);
            re = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Values (0xF and 0x0)", test_num);
            reset_dut();


            @(negedge clk);
            we = 1; d_in = 4'hF;
            @(negedge clk);
            we = 0; re = 1;
            @(negedge clk);


            re = 0; we = 1; d_in = 4'h0;
            @(negedge clk);
            we = 0; re = 1;
            @(negedge clk);

            #1;


            check_outputs(4'h0);
            re = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous Read and Write", test_num);
            reset_dut();


            @(negedge clk);
            we = 1;
            re = 1;
            d_in = 4'h7;
            @(negedge clk);


            #1;



            check_outputs(4'h7);
            we = 0;
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
        input [3:0] expected_d_out;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h",
                         d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h",
                         expected_d_out);
                $display("  Got:      d_out=%h",
                         d_out);
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
        $dumpvars(0,clk, d_in, re, we, d_out);
    end

endmodule
