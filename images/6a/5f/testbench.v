`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] ra;
    reg [4:0] rb;
    reg rst;
    reg [4:0] wa;
    reg [31:0] wdata;
    reg wen;
    wire [31:0] radata;
    wire [31:0] rbdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ra(ra),
        .rb(rb),
        .rst(rst),
        .wa(wa),
        .wdata(wdata),
        .wen(wen),
        .radata(radata),
        .rbdata(rbdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ra = 0;
            rb = 0;
            wa = 0;
            wdata = 0;
            wen = 0;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            ra = 5'd10;
            rb = 5'd20;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            wa = 5'd1;
            wdata = 32'hAAAA_BBBB;
            wen = 1;
            @(posedge clk);
            wen = 0;
            ra = 5'd1;
            rb = 5'd0;
            #1;

            check_outputs(32'hAAAA_BBBB, 32'h0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk);
            wa = 5'd0;
            wdata = 32'hFFFF_FFFF;
            wen = 1;
            @(posedge clk);
            wen = 0;
            ra = 5'd0;
            rb = 5'd0;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            @(posedge clk);
            wa = 5'd2; wdata = 32'h1234_5678; wen = 1;
            @(posedge clk);

            wa = 5'd3; wdata = 32'h8765_4321; wen = 1;
            @(posedge clk);
            wen = 0;
            ra = 5'd2;
            rb = 5'd3;
            #1;

            check_outputs(32'h1234_5678, 32'h8765_4321);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(posedge clk);
            wa = 5'd4;
            wdata = 32'hDEAD_BEEF;
            wen = 0;
            @(posedge clk);
            ra = 5'd4;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(posedge clk);
            wa = 5'd15;
            wdata = 32'h5555_AAAA;
            wen = 1;
            ra = 5'd15;
            rb = 5'd15;

            #1;


            check_outputs(32'h5555_AAAA, 32'h5555_AAAA);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            @(posedge clk);
            wa = 5'd7; wdata = 32'h1; wen = 1;
            @(posedge clk);
            wa = 5'd7; wdata = 32'h2; wen = 1;
            @(posedge clk);
            wen = 0;
            ra = 5'd7;
            #1;

            check_outputs(32'h2, 32'h0);
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
        testcase007();
        
        
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
        input [31:0] expected_radata;
        input [31:0] expected_rbdata;
        begin
            if (expected_radata === (expected_radata ^ radata ^ expected_radata) &&
                expected_rbdata === (expected_rbdata ^ rbdata ^ expected_rbdata)) begin
                $display("PASS");
                $display("  Outputs: radata=%h, rbdata=%h",
                         radata, rbdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: radata=%h, rbdata=%h",
                         expected_radata, expected_rbdata);
                $display("  Got:      radata=%h, rbdata=%h",
                         radata, rbdata);
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
        $dumpvars(0,clk, ra, rb, rst, wa, wdata, wen, radata, rbdata);
    end

endmodule
