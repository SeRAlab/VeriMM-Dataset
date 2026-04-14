`timescale 1ns/1ps

module bw_r_idct_array_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] addr;
    reg clk;
    reg [3:0] dec_wrway_y;
    reg [1:0] way;
    reg we;
    reg [32:0] wr_data;
    wire [32:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bw_r_idct_array dut (
        .addr(addr),
        .clk(clk),
        .dec_wrway_y(dec_wrway_y),
        .way(way),
        .we(we),
        .wr_data(wr_data),
        .rd_data(rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            addr = 0;
            wr_data = 0;
            dec_wrway_y = 0;
            way = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            addr = 7'h00;
            wr_data = 33'h1_FFFF_FFFF;
            we = 1;


            @(negedge clk);
            #2;

            we = 0;
            #1;

            check_outputs(33'h1_FFFF_FFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Address Write/Read", test_num);
            reset_dut();

            addr = 7'h7F;
            wr_data = 33'h0_A5A5_A5A5;
            we = 1;

            @(negedge clk);
            #2;

            we = 0;
            #1;

            check_outputs(33'h0_A5A5_A5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Check (we=0)", test_num);
            reset_dut();


            addr = 7'h10;
            wr_data = 33'h0_1234_5678;
            we = 1;
            @(negedge clk);
            #2;


            wr_data = 33'h1_AAAA_BBBB;
            we = 0;
            @(negedge clk);
            #2;


            #1;



            check_outputs(33'h0_1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Test", test_num);
            reset_dut();


            addr = 7'h25;
            wr_data = 33'h1_0000_0000;
            we = 1;
            @(negedge clk);
            #5;


            wr_data = 33'h0_C0DE_C0DE;
            @(negedge clk);
            #5;

            we = 0;
            #1;

            check_outputs(33'h0_C0DE_C0DE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Read Check", test_num);
            reset_dut();


            addr = 7'h0A;
            wr_data = 33'h1_AAAA_AAAA;
            we = 1;
            @(negedge clk);
            #2;


            addr = 7'h0B;
            wr_data = 33'h0_BBBB_BBBB;
            @(negedge clk);
            #2;

            we = 0;


            addr = 7'h0A;
            #1;


            #1;



            check_outputs(33'h1_AAAA_AAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Multi-address Write", test_num);
            reset_dut();

            we = 1;

            addr = 7'h01; wr_data = 33'h0_0000_0001; @(negedge clk); #1;

            addr = 7'h02; wr_data = 33'h0_0000_0002; @(negedge clk); #1;

            addr = 7'h03; wr_data = 33'h0_0000_0003; @(negedge clk); #1;

            we = 0;
            addr = 7'h02;
            #2;
            #1;

            check_outputs(33'h0_0000_0002);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bw_r_idct_array Testbench");
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
        input [32:0] expected_rd_data;
        begin
            if (expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data)) begin
                $display("PASS");
                $display("  Outputs: rd_data=%h",
                         rd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_data=%h",
                         expected_rd_data);
                $display("  Got:      rd_data=%h",
                         rd_data);
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
        $dumpvars(0,addr, clk, dec_wrway_y, way, we, wr_data, rd_data);
    end

endmodule
