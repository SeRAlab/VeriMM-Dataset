`timescale 1ns/1ps

module register_file_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg enable;
    reg [2:0] sel;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_file dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .sel(sel),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        enable = 0;
        sel = 0;
        data_in = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("testcase001: Basic Write and Read to Register 0");
        reset_dut();
        test_num = 1;

        sel = 3'b000;
        data_in = 32'h12345678;
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;

        #1;


        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        $display("testcase002: Write and Read to Register 7");
        reset_dut();
        test_num = 2;

        sel = 3'b111;
        data_in = 32'hDEADBEEF;
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;

        #1;


        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        $display("testcase003: Verify Write Enable (Writing while disabled)");
        reset_dut();
        test_num = 3;


        sel = 3'b010;
        data_in = 32'hAAAA_AAAA;
        enable = 1;
        @(posedge clk);
        #1;


        data_in = 32'h5555_5555;
        enable = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'hAAAA_AAAA);
    end
        endtask

    task testcase004;

    begin
        $display("testcase004: Overwrite value in Register 4");
        reset_dut();
        test_num = 4;


        sel = 3'b100;
        data_in = 32'h0000_1111;
        enable = 1;
        @(posedge clk);
        #1;


        data_in = 32'hFFFF_EEEE;
        @(posedge clk);
        #1;
        enable = 0;

        #1;


        check_outputs(32'hFFFF_EEEE);
    end
        endtask

    task testcase005;

    begin
        $display("testcase005: Data Persistence across registers");
        reset_dut();
        test_num = 5;


        sel = 3'b001;
        data_in = 32'hCAFE_BABE;
        enable = 1;
        @(posedge clk);
        #1;


        sel = 3'b010;
        data_in = 32'hBEEF_CAFE;
        enable = 1;
        @(posedge clk);
        #1;


        enable = 0;
        sel = 3'b001;
        #1;

        #1;


        check_outputs(32'hCAFE_BABE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_file Testbench");
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, enable, sel, data_out);
    end

endmodule
