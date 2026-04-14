`timescale 1ns/1ps

module reg_file_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] read_addr;
    reg rst;
    reg [2:0] write_addr;
    reg [15:0] write_data;
    reg write_en;
    wire [15:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file dut (
        .clk(clk),
        .read_addr(read_addr),
        .rst(rst),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_en(write_en),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            write_en = 0;
            write_addr = 0;
            write_data = 0;
            read_addr = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset Verification - Reading Reg 4", test_num);
            reset_dut();
            read_addr = 3'd4;
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Basic Write and Read - Reg 2", test_num);
            reset_dut();
            @(negedge clk);
            write_en = 1;
            write_addr = 3'd2;
            write_data = 16'hABCD;
            @(posedge clk);
            #1 write_en = 0;
            read_addr = 3'd2;
            #2;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Write Enable Check (Inactive)", test_num);
            reset_dut();
            @(negedge clk);
            write_en = 0;
            write_addr = 3'd5;
            write_data = 16'h5555;
            @(posedge clk);
            #1 read_addr = 3'd5;
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Overwriting Reg 7", test_num);
            reset_dut();

            @(negedge clk);
            write_en = 1;
            write_addr = 3'd7;
            write_data = 16'h1111;
            @(posedge clk);

            @(negedge clk);
            write_data = 16'hFFFF;
            @(posedge clk);
            #1 write_en = 0;
            read_addr = 3'd7;
            #2;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Read/Write Address Independence", test_num);
            reset_dut();
            @(negedge clk);
            write_en = 1;
            write_addr = 3'd1;
            write_data = 16'h1234;
            read_addr = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Test %0d: Multiple Sequential Writes", test_num);
            reset_dut();
            for(i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                write_en = 1;
                write_addr = i;
                write_data = i + 16'hA000;
                @(posedge clk);
            end
            #1 write_en = 0;
            read_addr = 3'd7;
            #2;
            #1;

            check_outputs(16'hA007);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Boundary Value 0xFFFF", test_num);
            reset_dut();
            @(negedge clk);
            write_en = 1;
            write_addr = 3'd3;
            write_data = 16'hFFFF;
            @(posedge clk);
            #1 write_en = 0;
            read_addr = 3'd3;
            #2;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file Testbench");
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
        input [15:0] expected_read_data;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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
        $dumpvars(0,clk, read_addr, rst, write_addr, write_data, write_en, read_data);
    end

endmodule
