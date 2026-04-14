`timescale 1ns/1ps

module memory_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] addr;
    reg clk;
    reg [15:0] data_in;
    reg rd_en;
    reg wr_en;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            data_in = 0;
            rd_en = 0;
            wr_en = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read", test_num);


            addr = 13'h0ABC;
            data_in = 16'h1234;
            wr_en = 1;
            rd_en = 0;
            @(posedge clk);
            #1;


            wr_en = 0;
            rd_en = 1;
            addr = 13'h0ABC;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Boundary Address 0", test_num);


            addr = 13'd0;
            data_in = 16'hFFFF;
            wr_en = 1;
            rd_en = 0;
            @(posedge clk);
            #1;


            wr_en = 0;
            rd_en = 1;
            addr = 13'd0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Max Address 8191", test_num);


            addr = 13'd8191;
            data_in = 16'hAAAA;
            wr_en = 1;
            rd_en = 0;
            @(posedge clk);
            #1;


            wr_en = 0;
            rd_en = 1;
            addr = 13'd8191;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Overwrite Data", test_num);


            addr = 13'h100;
            data_in = 16'h1111;
            wr_en = 1;
            @(posedge clk);
            #1;


            data_in = 16'h2222;
            @(posedge clk);
            #1;


            wr_en = 0;
            rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h2222);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Address Independence", test_num);


            addr = 13'd50;
            data_in = 16'h5555;
            wr_en = 1;
            @(posedge clk);
            #1;


            addr = 13'd51;
            data_in = 16'h6666;
            @(posedge clk);
            #1;


            wr_en = 0;
            rd_en = 1;
            addr = 13'd50;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Write Enable De-asserted", test_num);


            addr = 13'd200;
            data_in = 16'hDEAD;
            wr_en = 0;
            @(posedge clk);
            #1;


            rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Burst Write/Read End Check", test_num);


            wr_en = 1;
            addr = 13'd1000; data_in = 16'hD1; @(posedge clk); #1;
            addr = 13'd1001; data_in = 16'hD2; @(posedge clk); #1;
            addr = 13'd1002; data_in = 16'hD3; @(posedge clk); #1;


            wr_en = 0;
            rd_en = 1;
            addr = 13'd1000; @(posedge clk); #1;
            addr = 13'd1001; @(posedge clk); #1;
            addr = 13'd1002; @(posedge clk); #1;

            #1;


            check_outputs(16'hD3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory_module Testbench");
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
        $dumpvars(0,addr, clk, data_in, rd_en, wr_en, data_out);
    end

endmodule
