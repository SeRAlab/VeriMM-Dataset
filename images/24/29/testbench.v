`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] idata;
    reg re;
    reg we;
    wire [15:0] odata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .clk(clk),
        .idata(idata),
        .re(re),
        .we(we),
        .odata(odata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            idata <= 16'h0;
            we <= 1'b0;
            re <= 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (0xAAAA)", test_num);
            reset_dut();


            idata <= 16'hAAAA;
            we <= 1'b1;
            re <= 1'b0;
            @(posedge clk);
            #1;


            we <= 1'b0;
            re <= 1'b1;
            #1;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (0x5555)", test_num);
            reset_dut();


            idata <= 16'h5555;
            we <= 1'b1;
            re <= 1'b0;
            @(posedge clk);
            #1;


            we <= 1'b0;
            re <= 1'b1;
            #1;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Write Enable (WE=0)", test_num);
            reset_dut();


            idata <= 16'hBEEF;
            we <= 1'b1;
            re <= 1'b0;
            @(posedge clk);
            #1;


            idata <= 16'hDEAD;
            we <= 1'b0;
            @(posedge clk);
            #1;


            re <= 1'b1;
            #1;

            #1;


            check_outputs(16'hBEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Value All Zeros", test_num);
            reset_dut();

            idata <= 16'h0000;
            we <= 1'b1;
            re <= 1'b0;
            @(posedge clk);
            #1;

            we <= 1'b0;
            re <= 1'b1;
            #1;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Value All Ones", test_num);
            reset_dut();

            idata <= 16'hFFFF;
            we <= 1'b1;
            re <= 1'b0;
            @(posedge clk);
            #1;

            we <= 1'b0;
            re <= 1'b1;
            #1;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Overwrite", test_num);
            reset_dut();


            idata <= 16'h1111;
            we <= 1'b1;
            @(posedge clk);
            #1;


            idata <= 16'h2222;
            we <= 1'b1;
            @(posedge clk);
            #1;

            we <= 1'b0;
            re <= 1'b1;
            #1;

            #1;


            check_outputs(16'h2222);
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
        input [15:0] expected_odata;
        begin
            if (expected_odata === (expected_odata ^ odata ^ expected_odata)) begin
                $display("PASS");
                $display("  Outputs: odata=%h",
                         odata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: odata=%h",
                         expected_odata);
                $display("  Got:      odata=%h",
                         odata);
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
        $dumpvars(0,clk, idata, re, we, odata);
    end

endmodule
