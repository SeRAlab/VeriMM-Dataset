`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg [12:0] read_address;
    reg we;
    reg [12:0] write_address;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .read_address(read_address),
        .we(we),
        .write_address(write_address),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            d = 0;
            write_address = 0;
            read_address = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read", test_num);


            we = 1;
            write_address = 13'h050;
            d = 16'hABCD;
            @(posedge clk);


            we = 0;
            read_address = 13'h050;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Write Enable Check (Attempt write when WE=0)", test_num);


            we = 1;
            write_address = 13'h100;
            d = 16'h5555;
            @(posedge clk);


            we = 0;
            write_address = 13'h100;
            d = 16'hAAAA;
            @(posedge clk);


            read_address = 13'h100;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Sequential Writes", test_num);

            we = 1;
            write_address = 13'h001; d = 16'h1111; @(posedge clk);
            write_address = 13'h002; d = 16'h2222; @(posedge clk);
            write_address = 13'h003; d = 16'h3333; @(posedge clk);

            we = 0;
            read_address = 13'h002;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Boundary Address Test (Max Address)", test_num);


            we = 1;
            write_address = 13'h1FFF;
            d = 16'hFFFF;
            @(posedge clk);

            we = 0;
            read_address = 13'h1FFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);


            we = 1;
            write_address = 13'h010;
            d = 16'hCAFE;
            @(posedge clk);


            we = 1;
            read_address = 13'h010;
            write_address = 13'h020;
            d = 16'hBEEF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'hCAFE);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Data Overwrite Test", test_num);

            we = 1;
            write_address = 13'h777;
            d = 16'h1234;
            @(posedge clk);


            d = 16'h5678;
            @(posedge clk);

            we = 0;
            read_address = 13'h777;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h5678);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [15:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, read_address, we, write_address, q);
    end

endmodule
