`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] addr;
    reg clk;
    reg [7:0] din;
    reg en;
    reg we;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .en(en),
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
            en = 0;
            we = 0;
            addr = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read at Addr 0", test_num);
            reset_dut();


            @(negedge clk);
            addr = 9'h000;
            din = 8'hA5;
            en = 1;
            we = 1;
            @(negedge clk);


            we = 0;
            @(negedge clk);


            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read at Addr 511", test_num);
            reset_dut();


            @(negedge clk);
            addr = 9'h1FF;
            din = 8'h5A;
            en = 1;
            we = 1;
            @(negedge clk);


            we = 0;
            @(negedge clk);

            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify 'en' signal disables write", test_num);
            reset_dut();


            @(negedge clk);
            addr = 9'h010; din = 8'h11; en = 1; we = 1;
            @(negedge clk);


            addr = 9'h010; din = 8'hEE; en = 0; we = 1;
            @(negedge clk);


            en = 1; we = 0;
            @(negedge clk);

            #1;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify 'we' signal disables write", test_num);
            reset_dut();


            @(negedge clk);
            addr = 9'h020; din = 8'h22; en = 1; we = 1;
            @(negedge clk);


            addr = 9'h020; din = 8'hFF; en = 1; we = 0;
            @(negedge clk);


            @(negedge clk);

            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Consecutive multi-address writes and reads", test_num);
            reset_dut();


            @(negedge clk);
            addr = 9'h030; din = 8'h33; en = 1; we = 1;
            @(negedge clk);

            addr = 9'h031; din = 8'h44; en = 1; we = 1;
            @(negedge clk);


            addr = 9'h030; we = 0;
            @(negedge clk);

            addr = 9'h031;
            @(negedge clk);

            #1;
            #1;

            check_outputs(8'h44);
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
        input [7:0] expected_dout;
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
        $dumpvars(0,addr, clk, din, en, we, dout);
    end

endmodule
