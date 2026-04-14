`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] addr;
    reg clk;
    reg [15:0] din;
    reg write_en;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .write_en(write_en),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            din = 0;
            write_en = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic write and read at address 0", test_num);


            addr = 5'd0;
            din = 16'hAAAA;
            write_en = 1;
            @(posedge clk);
            #1;


            write_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write to address 15", test_num);

            addr = 5'd15;
            din = 16'h5555;
            write_en = 1;
            @(posedge clk);
            #1;

            write_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting an existing value", test_num);


            addr = 5'd10;
            din = 16'h1234;
            write_en = 1;
            @(posedge clk);
            #1;


            din = 16'hABCD;
            @(posedge clk);
            #1;

            write_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verify write_en=0 prevents writing", test_num);


            addr = 5'd20;
            din = 16'h1111;
            write_en = 1;
            @(posedge clk);
            #1;


            din = 16'hEEEE;
            write_en = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h1111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary address (31) write and read", test_num);

            addr = 5'd31;
            din = 16'hFFFF;
            write_en = 1;
            @(posedge clk);
            #1;

            write_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Data integrity across different addresses", test_num);


            addr = 5'd5;
            din = 16'hA1A1;
            write_en = 1;
            @(posedge clk);
            #1;


            addr = 5'd6;
            din = 16'hB2B2;
            write_en = 1;
            @(posedge clk);
            #1;


            write_en = 0;
            addr = 5'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hA1A1);
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
        $dumpvars(0,addr, clk, din, write_en, dout);
    end

endmodule
