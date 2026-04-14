`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] din;
    reg re;
    reg rst;
    reg we;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .clk(clk),
        .din(din),
        .re(re),
        .rst(rst),
        .we(we),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            we = 0;
            re = 0;
            din = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset and Initial Read", test_num);
            reset_dut();

            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Write and Read", test_num);
            reset_dut();


            din = 16'hABCD;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;


            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write Enable Check", test_num);
            reset_dut();


            din = 16'h1234;
            we = 0;
            @(posedge clk);
            #1;


            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Persistence Check", test_num);
            reset_dut();


            din = 16'h55AA;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;
            din = 16'hFFFF;


            repeat(2) @(posedge clk);
            #1;


            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Read Enable Gate Check", test_num);
            reset_dut();


            din = 16'hCAFE;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;


            re = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Mid-operation", test_num);
            reset_dut();


            din = 16'h9999;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;


            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;


            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overwrite Data", test_num);
            reset_dut();


            din = 16'h1111;
            we = 1;
            @(posedge clk);
            #1;


            din = 16'h2222;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;


            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h2222);
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
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,clk, din, re, rst, we, dout);
    end

endmodule
