`timescale 1ns/1ps

module reg_file_32bit_8reg_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] read_addr1;
    reg [2:0] read_addr2;
    reg rst_n;
    reg [2:0] write_addr;
    reg [31:0] write_data;
    reg write_en;
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file_32bit_8reg dut (
        .clk(clk),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .rst_n(rst_n),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_en(write_en),
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
            rst_n = 0;
            write_en = 0;
            write_addr = 0;
            write_data = 0;
            read_addr1 = 0;
            read_addr2 = 0;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Check reset (all registers should be 0)", test_num);
            reset_dut();

            read_addr1 = 3'd2;
            read_addr2 = 3'd5;
            #5;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write to Reg 1 and read back", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1;
            write_addr = 3'd1;
            write_data = 32'hDEADBEEF;
            @(posedge clk);
            write_en = 0;


            read_addr1 = 3'd1;
            read_addr2 = 3'd0;
            #5;
            #1;

            check_outputs(32'hDEADBEEF, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Write to Reg 4 and 7, then read both", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1;
            write_addr = 3'd4;
            write_data = 32'h12345678;
            @(posedge clk);


            write_addr = 3'd7;
            write_data = 32'h87654321;
            @(posedge clk);
            write_en = 0;


            read_addr1 = 3'd4;
            read_addr2 = 3'd7;
            #5;
            #1;

            check_outputs(32'h12345678, 32'h87654321);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Attempt write with write_en=0", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1;
            write_addr = 3'd2;
            write_data = 32'hAAAAAAAA;
            @(posedge clk);


            write_en = 0;
            write_addr = 3'd2;
            write_data = 32'hBBBBBBBB;
            @(posedge clk);

            read_addr1 = 3'd2;
            read_addr2 = 3'd0;
            #5;

            #1;


            check_outputs(32'hAAAAAAAA, 32'h00000000);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Fill all registers with unique patterns", test_num);
            reset_dut();

            for(i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                write_en = 1;
                write_addr = i[2:0];
                write_data = (32'hF0F0F0F0 ^ i);
            end
            @(posedge clk);
            write_en = 0;


            read_addr1 = 3'd3;
            read_addr2 = 3'd6;
            #5;
            #1;

            check_outputs(32'hF0F0F0F0 ^ 3, 32'hF0F0F0F0 ^ 6);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verify asynchronous reset mid-operation", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1;
            write_addr = 3'd5;
            write_data = 32'hFFFFFFFF;
            @(posedge clk);
            write_en = 0;


            read_addr1 = 3'd5;
            #5;
            if (read_data1 !== 32'hFFFFFFFF) $display("Setup for TC006 failed");


            #3 rst_n = 0;
            #10;
            read_addr1 = 3'd5;
            read_addr2 = 3'd5;
            #5;
            #1;

            check_outputs(32'h0, 32'h0);
            rst_n = 1;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file_32bit_8reg Testbench");
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
        $dumpvars(0,clk, read_addr1, read_addr2, rst_n, write_addr, write_data, write_en, read_data1, read_data2);
    end

endmodule
