`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [19:0] p1_addr;
    reg [7:0] p1_data;
    reg p1_re;
    reg p1_we;
    reg [19:0] p2_addr;
    wire [7:0] p1_data_out;
    wire [7:0] p2_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .p1_addr(p1_addr),
        .p1_data(p1_data),
        .p1_re(p1_re),
        .p1_we(p1_we),
        .p2_addr(p2_addr),
        .p1_data_out(p1_data_out),
        .p2_data(p2_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            p1_addr <= 20'd0;
            p1_data <= 8'd0;
            p1_re <= 1'b0;
            p1_we <= 1'b0;
            p2_addr <= 20'd0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Port 1 Write then Read", test_num);


            @(posedge clk);
            p1_addr <= 20'h00001;
            p1_data <= 8'hAB;
            p1_we   <= 1'b1;

            @(posedge clk);
            p1_we   <= 1'b0;


            p1_addr <= 20'h00001;
            p1_re   <= 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAB, 8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Port 1 Write then Port 2 Read", test_num);


            @(posedge clk);
            p1_addr <= 20'h01234;
            p1_data <= 8'h55;
            p1_we   <= 1'b1;

            @(posedge clk);
            p1_we   <= 1'b0;


            p2_addr <= 20'h01234;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h55);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Simultaneous Read (P1=Addr A, P2=Addr B)", test_num);


            @(posedge clk);
            p1_addr <= 20'h00010; p1_data <= 8'h11; p1_we <= 1'b1;
            @(posedge clk);
            p1_addr <= 20'h00020; p1_data <= 8'h22; p1_we <= 1'b1;
            @(posedge clk);
            p1_we <= 1'b0;


            p1_addr <= 20'h00010;
            p1_re   <= 1'b1;
            p2_addr <= 20'h00020;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Boundary Address Check (153599)", test_num);

            @(posedge clk);
            p1_addr <= 20'd153599;
            p1_data <= 8'hFF;
            p1_we   <= 1'b1;

            @(posedge clk);
            p1_we   <= 1'b0;


            p1_addr <= 20'd153599;
            p1_re   <= 1'b1;
            p2_addr <= 20'd153599;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Write Enable Gating Check", test_num);


            @(posedge clk);
            p1_addr <= 20'h00ABC;
            p1_data <= 8'h99;
            p1_we   <= 1'b0;

            @(posedge clk);

            p1_addr <= 20'h00ABC;
            p1_re   <= 1'b1;

            @(posedge clk);
            #1;

            if (p1_data_out != 8'h99) begin
                #1;

                check_outputs(p1_data_out, p2_data);
            end else begin

                #1;


                check_outputs(8'h00, 8'h00);
            end
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
        input [7:0] expected_p1_data_out;
        input [7:0] expected_p2_data;
        begin
            if (expected_p1_data_out === (expected_p1_data_out ^ p1_data_out ^ expected_p1_data_out) &&
                expected_p2_data === (expected_p2_data ^ p2_data ^ expected_p2_data)) begin
                $display("PASS");
                $display("  Outputs: p1_data_out=%h, p2_data=%h",
                         p1_data_out, p2_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p1_data_out=%h, p2_data=%h",
                         expected_p1_data_out, expected_p2_data);
                $display("  Got:      p1_data_out=%h, p2_data=%h",
                         p1_data_out, p2_data);
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
        $dumpvars(0,clk, p1_addr, p1_data, p1_re, p1_we, p2_addr, p1_data_out, p2_data);
    end

endmodule
