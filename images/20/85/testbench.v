`timescale 1ns/1ps

module sram_16bit_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [15:0] data_in;
    reg re;
    reg we;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_16bit dut (
        .addr(addr),
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
            addr = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read at Address 0", test_num);


            addr = 4'h0;
            data_in = 16'hABCD;
            we = 1;
            re = 0;
            @(posedge clk);
            #1;
            we = 0;


            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
            re = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read at Address 15", test_num);


            addr = 4'hF;
            data_in = 16'h1234;
            we = 1;
            re = 0;
            @(posedge clk);
            #1;
            we = 0;


            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
            re = 0;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting data at Address 7", test_num);


            addr = 4'h7;
            data_in = 16'hAAAA;
            we = 1;
            @(posedge clk);
            #1;


            data_in = 16'h5555;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;


            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555);
            re = 0;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Write Enable behavior", test_num);


            addr = 4'h3;
            data_in = 16'hBEEF;
            we = 1;
            @(posedge clk);
            #1;


            data_in = 16'hCAFE;
            we = 0;
            @(posedge clk);
            #1;


            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hBEEF);
            re = 0;
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Data persistence across multiple addresses", test_num);


            addr = 4'h2;
            data_in = 16'h1111;
            we = 1;
            @(posedge clk);
            #1;


            addr = 4'h8;
            data_in = 16'h8888;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;


            addr = 4'h2;
            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1111);
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
        $display("sram_16bit Testbench");
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,addr, clk, data_in, re, we, data_out);
    end

endmodule
