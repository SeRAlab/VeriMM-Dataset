`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg datain;
    reg [2:0] raddr;
    reg [2:0] waddr;
    reg we;
    reg write_reset;
    wire dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .datain(datain),
        .raddr(raddr),
        .waddr(waddr),
        .we(we),
        .write_reset(write_reset),
        .dataout(dataout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            write_reset = 1;
            we = 0;
            datain = 0;
            waddr = 0;
            raddr = 0;
            @(posedge clk);
            #1;
            write_reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Initialization", test_num);
            reset_dut();


            @(posedge clk);
            raddr = 3'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            waddr = 3'd5;
            datain = 1'b1;
            we = 1'b1;
            @(posedge clk);


            we = 1'b0;
            raddr = 3'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable (WE) Deactivated", test_num);
            reset_dut();


            @(posedge clk);
            waddr = 3'd2;
            datain = 1'b1;
            we = 1'b1;
            @(posedge clk);


            datain = 1'b0;
            we = 1'b0;
            @(posedge clk);


            raddr = 3'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address Independence", test_num);
            reset_dut();


            @(posedge clk);
            waddr = 3'd0;
            datain = 1'b1;
            we = 1'b1;
            @(posedge clk);


            waddr = 3'd1;
            datain = 1'b0;
            @(posedge clk);


            we = 1'b0;
            raddr = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            waddr = 3'd7;
            datain = 1'b1;
            we = 1'b1;
            @(posedge clk);


            waddr = 3'd6;
            datain = 1'b0;
            raddr = 3'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Mid-Operation", test_num);
            reset_dut();


            @(posedge clk);
            waddr = 3'd4;
            datain = 1'b1;
            we = 1'b1;
            @(posedge clk);


            write_reset = 1'b1;
            @(posedge clk);
            write_reset = 1'b0;


            raddr = 3'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_dataout;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%b",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%b",
                         expected_dataout);
                $display("  Got:      dataout=%b",
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
        $dumpvars(0,clk, datain, raddr, waddr, we, write_reset, dataout);
    end

endmodule
