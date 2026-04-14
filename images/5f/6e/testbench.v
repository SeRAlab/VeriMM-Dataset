`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [7:0] wdata;
    wire [7:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .wdata(wdata),
        .rdata(rdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 8'h0;
            wdata = 8'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read from Address 0", test_num);
            reset_dut();

            addr = 8'h00;
            wdata = 8'hA5;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read from Max Address (255)", test_num);
            reset_dut();

            addr = 8'hFF;
            wdata = 8'h5A;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read from Address 128", test_num);
            reset_dut();

            addr = 8'h80;
            wdata = 8'h12;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Successive writes to the same address", test_num);
            reset_dut();

            addr = 8'h20;
            wdata = 8'hCC;
            @(posedge clk);
            #2;

            wdata = 8'hDD;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hDD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify data persistence across addresses", test_num);
            reset_dut();


            addr = 8'h10;
            wdata = 8'hEE;
            @(posedge clk);
            #2;


            addr = 8'h11;
            wdata = 8'hFF;
            @(posedge clk);
            #2;


            addr = 8'h10;
            wdata = 8'h00;
            #2;

            #1;


            check_outputs(8'hEE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read-during-write check", test_num);
            reset_dut();

            addr = 8'h44;
            wdata = 8'h77;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h77);
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
        input [7:0] expected_rdata;
        begin
            if (expected_rdata === (expected_rdata ^ rdata ^ expected_rdata)) begin
                $display("PASS");
                $display("  Outputs: rdata=%h",
                         rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata=%h",
                         expected_rdata);
                $display("  Got:      rdata=%h",
                         rdata);
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
        $dumpvars(0,addr, clk, wdata, rdata);
    end

endmodule
