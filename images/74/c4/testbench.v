`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] read_reg1;
    reg [4:0] read_reg2;
    reg rst;
    reg [31:0] write_data;
    reg write_enable;
    reg [4:0] write_reg;
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .rst(rst),
        .write_data(write_data),
        .write_enable(write_enable),
        .write_reg(write_reg),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            write_enable = 0;
            write_reg = 0;
            write_data = 0;
            read_reg1 = 0;
            read_reg2 = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Check reset state", test_num);
            reset_dut();
            read_reg1 = 5'd5;
            read_reg2 = 5'd10;
            #2;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single write and dual read", test_num);
            reset_dut();


            write_enable = 1;
            write_reg = 5'd1;
            write_data = 32'hAAAA_BBBB;
            @(posedge clk);
            #1 write_enable = 0;


            read_reg1 = 5'd1;
            read_reg2 = 5'd2;
            #5;
            #1;

            check_outputs(32'hAAAA_BBBB, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Write two registers, read both", test_num);
            reset_dut();


            write_enable = 1;
            write_reg = 5'd10;
            write_data = 32'h1234_5678;
            @(posedge clk);


            write_reg = 5'd20;
            write_data = 32'h8765_4321;
            @(posedge clk);
            #1 write_enable = 0;


            read_reg1 = 5'd10;
            read_reg2 = 5'd20;
            #5;
            #1;

            check_outputs(32'h1234_5678, 32'h8765_4321);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write enable check (disable write)", test_num);
            reset_dut();

            write_enable = 0;
            write_reg = 5'd15;
            write_data = 32'hFFFF_FFFF;
            @(posedge clk);

            read_reg1 = 5'd15;
            read_reg2 = 5'd0;
            #5;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Overwrite register", test_num);
            reset_dut();


            write_enable = 1;
            write_reg = 5'd7;
            write_data = 32'h1111_1111;
            @(posedge clk);


            write_data = 32'h2222_2222;
            @(posedge clk);
            #1 write_enable = 0;

            read_reg1 = 5'd7;
            read_reg2 = 5'd7;
            #5;
            #1;

            check_outputs(32'h2222_2222, 32'h2222_2222);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Register 31 check", test_num);
            reset_dut();

            write_enable = 1;
            write_reg = 5'd31;
            write_data = 32'h55AA_55AA;
            @(posedge clk);
            #1 write_enable = 0;

            read_reg1 = 5'd31;
            read_reg2 = 5'd0;
            #5;
            #1;

            check_outputs(32'h55AA_55AA, 32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Rapid sequential writes", test_num);
            reset_dut();

            write_enable = 1;
            write_reg = 5'd2; write_data = 32'hD1; @(posedge clk);
            write_reg = 5'd3; write_data = 32'hD2; @(posedge clk);
            write_reg = 5'd4; write_data = 32'hD3; @(posedge clk);
            #1 write_enable = 0;

            read_reg1 = 5'd2;
            read_reg2 = 5'd4;
            #5;
            #1;

            check_outputs(32'h000000D1, 32'h000000D3);
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
        input [31:0] expected_read_data1;
        input [31:0] expected_read_data2;
        begin
            if (expected_read_data1 === (expected_read_data1 ^ read_data1 ^ expected_read_data1) &&
                expected_read_data2 === (expected_read_data2 ^ read_data2 ^ expected_read_data2)) begin
                $display("PASS");
                $display("  Outputs: read_data1=%h, read_data2=%h",
                         read_data1, read_data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data1=%h, read_data2=%h",
                         expected_read_data1, expected_read_data2);
                $display("  Got:      read_data1=%h, read_data2=%h",
                         read_data1, read_data2);
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
        $dumpvars(0,clk, read_reg1, read_reg2, rst, write_data, write_enable, write_reg, read_data1, read_data2);
    end

endmodule
