`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] din;
    reg rd_en;
    reg wr_en;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .clk(clk),
        .din(din),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_en <= 0;
            rd_en <= 0;
            din   <= 16'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (0xAAAA)", test_num);
            reset_dut();


            wr_en <= 1;
            din   <= 16'hAAAA;
            @(posedge clk);
            #1;
            wr_en <= 0;


            rd_en <= 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hAAAA);
            rd_en <= 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (0x5555)", test_num);
            reset_dut();


            wr_en <= 1;
            din   <= 16'h5555;
            @(posedge clk);
            #1;
            wr_en <= 0;


            rd_en <= 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h5555);
            rd_en <= 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting data (0x1234 -> 0x4321)", test_num);
            reset_dut();


            wr_en <= 1;
            din   <= 16'h1234;
            @(posedge clk);
            #1;


            din   <= 16'h4321;
            @(posedge clk);
            #1;
            wr_en <= 0;


            rd_en <= 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h4321);
            rd_en <= 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify wr_en is required to change data", test_num);
            reset_dut();


            wr_en <= 1;
            din   <= 16'hBEEF;
            @(posedge clk);
            #1;
            wr_en <= 0;


            din   <= 16'hDEAD;
            @(posedge clk);
            #1;


            rd_en <= 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'hBEEF);
            rd_en <= 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary values (0xFFFF)", test_num);
            reset_dut();


            wr_en <= 1;
            din   <= 16'hFFFF;
            @(posedge clk);
            #1;
            wr_en <= 0;


            rd_en <= 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFF);
            rd_en <= 0;
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
        $dumpvars(0,clk, din, rd_en, wr_en, dout);
    end

endmodule
