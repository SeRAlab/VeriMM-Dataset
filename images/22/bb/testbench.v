`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr;
    reg clk;
    reg [3:0] din;
    reg re;
    reg we;
    wire [3:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .re(re),
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
            addr = 2'b0;
            din = 4'b0;
            we = 1'b0;
            re = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            addr = 2'b00;
            din = 4'hA;
            we = 1'b1;
            @(posedge clk);
            #1 we = 1'b0;


            re = 1'b1;
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            addr = 2'b11;
            din = 4'h5;
            we = 1'b1;
            @(posedge clk);
            #1 we = 1'b0;


            re = 1'b1;
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            addr = 2'b01;
            din = 4'hF;
            we = 1'b1;
            @(posedge clk);
            #1;

            addr = 2'b10;
            din = 4'hC;
            we = 1'b1;
            @(posedge clk);
            #1 we = 1'b0;


            addr = 2'b01;
            re = 1'b1;
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            addr = 2'b00;
            din = 4'h1;
            we = 1'b1;
            @(posedge clk);
            #1;

            din = 4'h9;
            @(posedge clk);
            #1 we = 1'b0;


            re = 1'b1;
            #2;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            addr = 2'b10;
            din = 4'h7;
            we = 1'b1;
            @(posedge clk);
            #1;

            din = 4'hE;
            we = 1'b0;
            @(posedge clk);
            #1;


            re = 1'b1;
            #2;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;

            addr = 2'b01;
            din = 4'hB;
            we = 1'b1;
            @(posedge clk);
            #1 we = 1'b0;


            re = 1'b0;
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [3:0] expected_dout;
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
        $dumpvars(0,addr, clk, din, re, we, dout);
    end

endmodule
