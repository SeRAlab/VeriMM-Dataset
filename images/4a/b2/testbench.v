`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] datain;
    reg [8:0] rdaddr;
    reg re;
    reg we;
    reg [8:0] wraddr;
    wire [7:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .datain(datain),
        .rdaddr(rdaddr),
        .re(re),
        .we(we),
        .wraddr(wraddr),
        .dataout(dataout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            re = 0;
            we = 0;
            rdaddr = 0;
            wraddr = 0;
            datain = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            we = 1;
            wraddr = 9'h010;
            datain = 8'hAA;
            @(posedge clk);
            #1;
            we = 0;


            re = 1;
            rdaddr = 9'h010;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting Memory Location", test_num);
            reset_dut();


            we = 1;
            wraddr = 9'h020;
            datain = 8'h11;
            @(posedge clk);
            #1;


            datain = 8'h22;
            @(posedge clk);
            #1;
            we = 0;


            re = 1;
            rdaddr = 9'h020;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address (0x1FF)", test_num);
            reset_dut();


            we = 1;
            wraddr = 9'h1FF;
            datain = 8'h55;
            @(posedge clk);
            #1;
            we = 0;


            re = 1;
            rdaddr = 9'h1FF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable De-asserted", test_num);
            reset_dut();


            we = 1;
            wraddr = 9'h050;
            datain = 8'hCC;
            @(posedge clk);
            #1;


            we = 0;
            datain = 8'hDD;
            @(posedge clk);
            #1;


            re = 1;
            rdaddr = 9'h050;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Read/Write", test_num);
            reset_dut();


            we = 1;
            wraddr = 9'h060;
            datain = 8'h66;
            @(posedge clk);
            #1;


            we = 1;
            wraddr = 9'h070;
            datain = 8'h77;
            re = 1;
            rdaddr = 9'h060;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h66);
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
        input [7:0] expected_dataout;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h",
                         expected_dataout);
                $display("  Got:      dataout=%h",
                         dataout);
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
        $dumpvars(0,clk, datain, rdaddr, re, we, wraddr, dataout);
    end

endmodule
