`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg rd_en;
    reg wr_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
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
            addr = 3'b0;
            data_in = 8'b0;
            rd_en = 0;
            wr_en = 0;
            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write/Read at Address 0", test_num);
            reset_dut();


            addr = 3'd0;
            data_in = 8'hA5;
            wr_en = 1;
            rd_en = 0;
            @(posedge clk);


            wr_en = 0;
            rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential Writes and Single Read at boundary", test_num);
            reset_dut();


            addr = 3'd1;
            data_in = 8'h55;
            wr_en = 1;
            @(posedge clk);


            addr = 3'd7;
            data_in = 8'hFF;
            wr_en = 1;
            @(posedge clk);


            wr_en = 0;
            rd_en = 1;
            addr = 3'd7;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overwrite Data at Address 3", test_num);
            reset_dut();


            addr = 3'd3;
            data_in = 8'h11;
            wr_en = 1;
            @(posedge clk);


            data_in = 8'hEE;
            wr_en = 1;
            @(posedge clk);


            wr_en = 0;
            rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hEE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Address Isolation (Crosstalk check)", test_num);
            reset_dut();


            addr = 3'd2;
            data_in = 8'hAA;
            wr_en = 1;
            @(posedge clk);


            addr = 3'd4;
            data_in = 8'hBB;
            wr_en = 1;
            @(posedge clk);


            wr_en = 0;
            rd_en = 1;
            addr = 3'd2;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Retention/Refresh Simulation", test_num);
            reset_dut();


            addr = 3'd5;
            data_in = 8'h77;
            wr_en = 1;
            @(posedge clk);


            wr_en = 0;
            rd_en = 0;
            repeat (10) @(posedge clk);


            rd_en = 1;
            addr = 3'd5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h77);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Sequential Reads", test_num);
            reset_dut();


            addr = 3'd0; data_in = 8'h10; wr_en = 1; @(posedge clk);
            addr = 3'd1; data_in = 8'h20; wr_en = 1; @(posedge clk);


            wr_en = 0;
            rd_en = 1;
            addr = 3'd0; @(posedge clk);
            addr = 3'd1; @(posedge clk);
            #1;

            #1;


            check_outputs(8'h20);
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
        input [7:0] expected_data_out;
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
