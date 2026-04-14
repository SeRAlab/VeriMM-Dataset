`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg re;
    reg rst;
    reg we;
    wire [7:0] dout;

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
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read", test_num);
            reset_dut();

            we = 1;
            din = 8'hA5;
            @(posedge clk);

            we = 0;
            re = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Reset (Clear stored value)", test_num);
            reset_dut();

            re = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write Enable Control Check", test_num);
            reset_dut();

            we = 0;
            din = 8'hFF;
            @(posedge clk);

            re = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overwriting Value", test_num);
            reset_dut();

            we = 1;
            din = 8'h12;
            @(posedge clk);

            din = 8'h34;
            @(posedge clk);

            we = 0;
            re = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h34);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Read Enable Control Check", test_num);
            reset_dut();

            we = 1;
            din = 8'hAA;
            @(posedge clk);

            we = 0;
            re = 0;
            @(posedge clk);

            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Value (0xFF)", test_num);
            reset_dut();
            we = 1;
            din = 8'hFF;
            @(posedge clk);
            we = 0;
            re = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hFF);
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
        $dumpvars(0,clk, din, re, rst, we, dout);
    end

endmodule
