`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr_A;
    reg [3:0] addr_B;
    reg clk;
    reg [7:0] data_in_A;
    reg [7:0] data_in_B;
    reg rd_en_A;
    reg rd_en_B;
    reg wr_en_A;
    reg wr_en_B;
    wire [7:0] data_out_A;
    wire [7:0] data_out_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_A(addr_A),
        .addr_B(addr_B),
        .clk(clk),
        .data_in_A(data_in_A),
        .data_in_B(data_in_B),
        .rd_en_A(rd_en_A),
        .rd_en_B(rd_en_B),
        .wr_en_A(wr_en_A),
        .wr_en_B(wr_en_B),
        .data_out_A(data_out_A),
        .data_out_B(data_out_B)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr_A = 0;
            addr_B = 0;
            data_in_A = 0;
            data_in_B = 0;
            rd_en_A = 0;
            rd_en_B = 0;
            wr_en_A = 0;
            wr_en_B = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Basic Write and Read on Port A", test_num);


            @(posedge clk);
            wr_en_A = 1;
            addr_A = 4'h1;
            data_in_A = 8'hAA;

            @(posedge clk);
            wr_en_A = 0;
            rd_en_A = 1;
            addr_A = 4'h1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Basic Write and Read on Port B", test_num);


            @(posedge clk);
            wr_en_B = 1;
            addr_B = 4'hF;
            data_in_B = 8'hBB;

            @(posedge clk);
            wr_en_B = 0;
            rd_en_B = 1;
            addr_B = 4'hF;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'hBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Simultaneous Write to Different Addresses", test_num);


            @(posedge clk);
            wr_en_A = 1; addr_A = 4'h2; data_in_A = 8'h11;
            wr_en_B = 1; addr_B = 4'h3; data_in_B = 8'h22;


            @(posedge clk);
            wr_en_A = 0; wr_en_B = 0;
            rd_en_A = 1; addr_A = 4'h3;
            rd_en_B = 1; addr_B = 4'h2;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22, 8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Simultaneous Read from Same Address", test_num);


            @(posedge clk);
            wr_en_A = 1; addr_A = 4'h5; data_in_A = 8'h55;


            @(posedge clk);
            wr_en_A = 0;
            rd_en_A = 1; addr_A = 4'h5;
            rd_en_B = 1; addr_B = 4'h5;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Port A Read / Port B Write simultaneously", test_num);


            @(posedge clk);
            wr_en_A = 1; addr_A = 4'h8; data_in_A = 8'h88;


            @(posedge clk);
            wr_en_A = 0; rd_en_A = 1; addr_A = 4'h8;
            wr_en_B = 1; addr_B = 4'h9; data_in_B = 8'h99;

            @(posedge clk);

            #1;
            if (data_out_A == 8'h88) begin

                rd_en_A = 0; wr_en_B = 0;
                rd_en_B = 1; addr_B = 4'h9;
                @(posedge clk);
                #1;
                #1;

                check_outputs(8'h00, 8'h99);
            end else begin
                #1;

                check_outputs(8'h88, 8'hFF);
            end
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %0d: Fill Memory and Verify", test_num);

            for (i = 0; i < 16; i = i + 2) begin
                @(posedge clk);
                wr_en_A = 1; addr_A = i[3:0]; data_in_A = i[7:0] + 8'h10;
                wr_en_B = 1; addr_B = (i+1); data_in_B = (i[7:0]+1) + 8'h10;
            end

            @(posedge clk);
            wr_en_A = 0; wr_en_B = 0;


            rd_en_A = 1; addr_A = 4'hE;
            rd_en_B = 1; addr_B = 4'hF;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h1E, 8'h1F);
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
        input [7:0] expected_data_out_A;
        input [7:0] expected_data_out_B;
        begin
            if (expected_data_out_A === (expected_data_out_A ^ data_out_A ^ expected_data_out_A) &&
                expected_data_out_B === (expected_data_out_B ^ data_out_B ^ expected_data_out_B)) begin
                $display("PASS");
                $display("  Outputs: data_out_A=%h, data_out_B=%h",
                         data_out_A, data_out_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_A=%h, data_out_B=%h",
                         expected_data_out_A, expected_data_out_B);
                $display("  Got:      data_out_A=%h, data_out_B=%h",
                         data_out_A, data_out_B);
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
        $dumpvars(0,addr_A, addr_B, clk, data_in_A, data_in_B, rd_en_A, rd_en_B, wr_en_A, wr_en_B, data_out_A, data_out_B);
    end

endmodule
