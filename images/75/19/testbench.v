`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] datain;
    reg [8:0] rdaddr;
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
        we = 0;
        datain = 0;
        rdaddr = 0;
        wraddr = 0;
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
        #1;
        we = 1;
        wraddr = 9'd10;
        datain = 8'hA5;

        @(posedge clk);
        #1;
        we = 0;
        rdaddr = 9'd10;

        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Write Enable (WE) verification", test_num);


        @(posedge clk);
        #1;
        we = 1;
        wraddr = 9'd20;
        datain = 8'h55;


        @(posedge clk);
        #1;
        we = 0;
        wraddr = 9'd20;
        datain = 8'hAA;


        @(posedge clk);
        #1;
        rdaddr = 9'd20;

        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Multiple address storage", test_num);


        @(posedge clk); #1; we = 1; wraddr = 9'd100; datain = 8'h11;

        @(posedge clk); #1; we = 1; wraddr = 9'd200; datain = 8'h22;

        @(posedge clk);
        #1;
        we = 0;
        rdaddr = 9'd100;
        @(posedge clk);
        #1;

        if (dataout !== 8'h11) begin
            $display("FAIL: Addr 100 corrupted");
            fail_count = fail_count + 1;
        end else begin
            rdaddr = 9'd200;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22);
        end
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Boundary address (511) check", test_num);

        @(posedge clk);
        #1;
        we = 1;
        wraddr = 9'd511;
        datain = 8'hFF;

        @(posedge clk);
        #1;
        we = 0;
        rdaddr = 9'd511;

        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Data overwrite check", test_num);


        @(posedge clk); #1; we = 1; wraddr = 9'd5; datain = 8'h10;

        @(posedge clk); #1; we = 1; wraddr = 9'd5; datain = 8'h20;

        @(posedge clk);
        #1;
        we = 0;
        rdaddr = 9'd5;

        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h20);
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
        $dumpvars(0,clk, datain, rdaddr, we, wraddr, dataout);
    end

endmodule
