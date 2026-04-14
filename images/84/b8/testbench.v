`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr_r;
    reg [3:0] addr_w;
    reg [7:0] data_in;
    reg rd_en;
    reg wr_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_r(addr_r),
        .addr_w(addr_w),
        .data_in(data_in),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        rd_en = 0;
        forever #5 rd_en = ~rd_en;
    end

        task reset_dut;

        begin
            wr_en = 0;
            addr_w = 0;
            addr_r = 0;
            data_in = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write/Read", test_num);
            reset_dut();


            addr_w = 4'h1;
            data_in = 8'hA5;
            #10;
            wr_en = 1;
            #10;
            wr_en = 0;


            addr_r = 4'h1;
            @(posedge rd_en);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address (Max)", test_num);
            reset_dut();


            addr_w = 4'hF;
            data_in = 8'h5A;
            #10;
            wr_en = 1;
            #10;
            wr_en = 0;

            addr_r = 4'hF;
            @(posedge rd_en);
            #2;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address Isolation", test_num);
            reset_dut();


            addr_w = 4'h2; data_in = 8'h11;
            #10; wr_en = 1; #10; wr_en = 0;


            addr_w = 4'h3; data_in = 8'h22;
            #10; wr_en = 1; #10; wr_en = 0;


            addr_r = 4'h2;
            @(posedge rd_en);
            #2;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Overwrite", test_num);
            reset_dut();


            addr_w = 4'h7; data_in = 8'hCC;
            #10; wr_en = 1; #10; wr_en = 0;


            addr_w = 4'h7; data_in = 8'h33;
            #10; wr_en = 1; #10; wr_en = 0;

            addr_r = 4'h7;
            @(posedge rd_en);
            #2;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit Integrity (0x00 and 0xFF)", test_num);
            reset_dut();


            addr_w = 4'h0; data_in = 8'hFF;
            #10; wr_en = 1; #10; wr_en = 0;
            addr_r = 4'h0;
            @(posedge rd_en); #2;
            #1;

            check_outputs(8'hFF);


            addr_w = 4'h0; data_in = 8'h00;
            #10; wr_en = 1; #10; wr_en = 0;
            @(posedge rd_en); #2;
            #1;

            check_outputs(8'h00);
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
        $dumpvars(0,addr_r, addr_w, data_in, rd_en, wr_en, data_out);
    end

endmodule
