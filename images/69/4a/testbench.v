`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_en;
    reg [43:0] data;
    reg [4:0] rd_addr;
    reg [4:0] wr_addr;
    wire [43:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_en(clk_en),
        .data(data),
        .rd_addr(rd_addr),
        .wr_addr(wr_addr),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clk_en = 0;
            wr_addr = 0;
            rd_addr = 0;
            data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Write and Read", test_num);


            @(negedge clk);
            wr_addr = 5'd5;
            data = 44'h123456789AB;
            clk_en = 1;
            @(negedge clk);
            clk_en = 0;


            rd_addr = 5'd5;
            @(negedge clk);

            #1;


            check_outputs(44'h123456789AB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write Enable (clk_en) Check", test_num);


            @(negedge clk);
            wr_addr = 5'd10;
            data = 44'hAAAAAAAAAAA;
            clk_en = 1;
            @(negedge clk);


            wr_addr = 5'd10;
            data = 44'h55555555555;
            clk_en = 0;
            @(negedge clk);


            rd_addr = 5'd10;
            @(negedge clk);


            #1;



            check_outputs(44'hAAAAAAAAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Multiple Write Access", test_num);

            @(negedge clk);
            clk_en = 1;
            wr_addr = 5'd0; data = 44'h0; @(negedge clk);
            wr_addr = 5'd1; data = 44'h1; @(negedge clk);
            wr_addr = 5'd2; data = 44'h2; @(negedge clk);
            wr_addr = 5'd3; data = 44'h3; @(negedge clk);
            clk_en = 0;

            rd_addr = 5'd2;
            @(negedge clk);
            #1;

            check_outputs(44'h2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Boundary Address Check (Addr 31)", test_num);

            @(negedge clk);
            wr_addr = 5'd31;
            data = 44'hFFFFFFFFFFF;
            clk_en = 1;
            @(negedge clk);
            clk_en = 0;

            rd_addr = 5'd31;
            @(negedge clk);

            #1;


            check_outputs(44'hFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Simultaneous Read/Write Different Addr", test_num);


            @(negedge clk);
            wr_addr = 5'd15;
            data = 44'hDEADC0DE000;
            clk_en = 1;
            @(negedge clk);


            rd_addr = 5'd15;
            wr_addr = 5'd16;
            data = 44'hBEEFCAFE111;
            clk_en = 1;
            @(negedge clk);


            #1;



            check_outputs(44'hDEADC0DE000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Large Value Data Integrity", test_num);

            @(negedge clk);
            wr_addr = 5'd20;
            data = 44'h2AAAAAAAAAA;
            clk_en = 1;
            @(negedge clk);
            clk_en = 0;

            rd_addr = 5'd20;
            @(negedge clk);

            #1;


            check_outputs(44'h2AAAAAAAAAA);
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
        input [43:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, clk_en, data, rd_addr, wr_addr, q);
    end

endmodule
