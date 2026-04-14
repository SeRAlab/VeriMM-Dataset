`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg clk;
    reg [31:0] datain;
    reg we;
    wire [31:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .datain(datain),
        .we(we),
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
            addr = 0;
            datain = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Write and Read (Addr 0)", test_num);


            addr = 32'h0000_0000;
            datain = 32'h1234_5678;
            we = 1;
            @(posedge clk);
            #2;


            we = 0;
            #1;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write/Read to Upper Index (4'hF)", test_num);

            addr = 32'hF000_0000;
            datain = 32'hDEAD_BEEF;
            we = 1;
            @(posedge clk);
            #2;

            we = 0;
            #1;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Verify Write Enable (we=0)", test_num);


            addr = 32'h5000_0000;
            datain = 32'hAAAA_BBBB;
            we = 1;
            @(posedge clk);
            #2;


            datain = 32'hFFFF_FFFF;
            we = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Verify 32-element range (Index 31)", test_num);

            addr = 32'hF800_0000;
            datain = 32'hCAFE_BABE;
            we = 1;
            @(posedge clk);
            #2;

            we = 0;
            #1;
            #1;

            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Multiple Word Persistence", test_num);


            addr = 32'h1000_0000;
            datain = 32'h0000_1111;
            we = 1;
            @(posedge clk);
            #2;


            addr = 32'h2000_0000;
            datain = 32'h2222_3333;
            we = 1;
            @(posedge clk);
            #2;


            we = 0;
            addr = 32'h1000_0000;
            #5;
            #1;

            check_outputs(32'h0000_1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Verify Initialization to Zero", test_num);


            addr = 32'h7000_0000;
            we = 0;
            #5;


            #1;



            check_outputs(32'h0000_0000);
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
        input [31:0] expected_dataout;
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
        $dumpvars(0,addr, clk, datain, we, dataout);
    end

endmodule
