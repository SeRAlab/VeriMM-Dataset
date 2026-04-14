`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg re;
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
            we = 0;
            re = 0;
            din = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            we = 1;
            din = 8'hA5;
            @(posedge clk);
            #1;
            we = 0;

            re = 1;
            #2;
            $display("Testcase %0d: Basic Write/Read (0xA5)", test_num);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            we = 1; din = 8'h55;
            @(posedge clk);
            #1;

            we = 0; din = 8'hFF;
            @(posedge clk);
            #1;

            re = 1;
            #2;
            $display("Testcase %0d: Verify Write Enable Logic", test_num);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            we = 1; din = 8'h11;
            @(posedge clk);
            #1;

            din = 8'h22;
            @(posedge clk);
            #1;

            din = 8'h33;
            @(posedge clk);
            #1;
            we = 0;
            re = 1;
            #2;
            $display("Testcase %0d: Sequential Writes (Last should be 0x33)", test_num);
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            we = 1; din = 8'hFF;
            @(posedge clk);
            #1;
            we = 0; re = 1;
            #2;
            $display("Testcase %0d: Data 0xFF", test_num);
            #1;

            check_outputs(8'hFF);


            reset_dut();
            we = 1; din = 8'h00;
            @(posedge clk);
            #1;
            we = 0; re = 1;
            #2;
            $display("Testcase %0d: Data 0x00", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            we = 1; din = 8'hBC;
            @(posedge clk);
            #1;
            we = 0;
            re = 0;
            #10;
            re = 1;
            #2;
            $display("Testcase %0d: Data Persistence with RE toggle", test_num);
            #1;

            check_outputs(8'hBC);
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
        $dumpvars(0,clk, din, re, we, dout);
    end

endmodule
