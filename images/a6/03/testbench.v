`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg I_clk;
    reg I_reg_we;
    reg [4:0] I_rs_addr;
    reg [4:0] I_rt_addr;
    reg [4:0] I_wb_addr;
    reg [31:0] I_wb_data;
    wire [31:0] O_rs_data;
    wire [31:0] O_rt_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I_clk(I_clk),
        .I_reg_we(I_reg_we),
        .I_rs_addr(I_rs_addr),
        .I_rt_addr(I_rt_addr),
        .I_wb_addr(I_wb_addr),
        .I_wb_data(I_wb_data),
        .O_rs_data(O_rs_data),
        .O_rt_data(O_rt_data)
    );

    // Clock generation (10ns period)
    initial begin
        I_clk = 0;
        forever #5 I_clk = ~I_clk;
    end

        task reset_dut;

    begin
        I_reg_we = 0;
        I_rs_addr = 0;
        I_rt_addr = 0;
        I_wb_addr = 0;
        I_wb_data = 0;
        @(posedge I_clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Basic Write/Read (Reg 1)", test_num);


        I_reg_we = 1;
        I_wb_addr = 5'd1;
        I_wb_data = 32'h12345678;
        @(posedge I_clk);
        #1;


        I_reg_we = 0;
        I_rs_addr = 5'd1;
        I_rt_addr = 5'd1;
        #1;

        #1;


        check_outputs(32'h12345678, 32'h12345678);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Register 0 Hardwired to Zero", test_num);


        I_reg_we = 1;
        I_wb_addr = 5'd0;
        I_wb_data = 32'hFFFFFFFF;
        @(posedge I_clk);
        #1;


        I_reg_we = 0;
        I_rs_addr = 5'd0;
        I_rt_addr = 5'd0;
        #1;


        #1;



        check_outputs(32'h00000000, 32'h00000000);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Multiple Register Access", test_num);


        I_reg_we = 1;
        I_wb_addr = 5'd10;
        I_wb_data = 32'hAAAA_BBBB;
        @(posedge I_clk);
        #1;


        I_wb_addr = 5'd20;
        I_wb_data = 32'hCCCC_DDDD;
        @(posedge I_clk);
        #1;


        I_reg_we = 0;
        I_rs_addr = 5'd10;
        I_rt_addr = 5'd20;
        #1;

        #1;


        check_outputs(32'hAAAA_BBBB, 32'hCCCC_DDDD);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Write Enable Control", test_num);


        I_reg_we = 1;
        I_wb_addr = 5'd5;
        I_wb_data = 32'h5555_5555;
        @(posedge I_clk);
        #1;


        I_reg_we = 0;
        I_wb_addr = 5'd5;
        I_wb_data = 32'hEEEE_EEEE;
        @(posedge I_clk);
        #1;


        I_rs_addr = 5'd5;
        I_rt_addr = 5'd5;
        #1;


        #1;



        check_outputs(32'h5555_5555, 32'h5555_5555);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Boundary Address (Reg 31)", test_num);


        I_reg_we = 1;
        I_wb_addr = 5'd31;
        I_wb_data = 32'h87654321;
        @(posedge I_clk);
        #1;

        I_reg_we = 0;
        I_rs_addr = 5'd31;
        I_rt_addr = 5'd0;
        #1;

        #1;


        check_outputs(32'h87654321, 32'h00000000);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Overwriting Register Data", test_num);


        I_reg_we = 1;
        I_wb_addr = 5'd15;
        I_wb_data = 32'h1111_1111;
        @(posedge I_clk);
        #1;


        I_wb_data = 32'h2222_2222;
        @(posedge I_clk);
        #1;

        I_reg_we = 0;
        I_rs_addr = 5'd15;
        I_rt_addr = 5'd15;
        #1;

        #1;


        check_outputs(32'h2222_2222, 32'h2222_2222);
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
        input [31:0] expected_O_rs_data;
        input [31:0] expected_O_rt_data;
        begin
            if (expected_O_rs_data === (expected_O_rs_data ^ O_rs_data ^ expected_O_rs_data) &&
                expected_O_rt_data === (expected_O_rt_data ^ O_rt_data ^ expected_O_rt_data)) begin
                $display("PASS");
                $display("  Outputs: O_rs_data=%h, O_rt_data=%h",
                         O_rs_data, O_rt_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O_rs_data=%h, O_rt_data=%h",
                         expected_O_rs_data, expected_O_rt_data);
                $display("  Got:      O_rs_data=%h, O_rt_data=%h",
                         O_rs_data, O_rt_data);
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
        $dumpvars(0,I_clk, I_reg_we, I_rs_addr, I_rt_addr, I_wb_addr, I_wb_data, O_rs_data, O_rt_data);
    end

endmodule
