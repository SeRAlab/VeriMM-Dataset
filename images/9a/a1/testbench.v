`timescale 1ns/1ps

module regfile32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] rd_addr1;
    reg [1:0] rd_addr2;
    reg rst;
    reg we;
    reg [1:0] wr_addr;
    reg [31:0] wr_data;
    wire [31:0] rd_data1;
    wire [31:0] rd_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    regfile32bit dut (
        .clk(clk),
        .rd_addr1(rd_addr1),
        .rd_addr2(rd_addr2),
        .rst(rst),
        .we(we),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .rd_data1(rd_data1),
        .rd_data2(rd_data2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            we = 0;
            wr_addr = 0;
            wr_data = 0;
            rd_addr1 = 0;
            rd_addr2 = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();
            rd_addr1 = 2'b01;
            rd_addr2 = 2'b11;
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Port Write and Read");
            reset_dut();
            @(negedge clk);
            we = 1; wr_addr = 2'b00; wr_data = 32'hDEADBEEF;
            @(negedge clk);
            we = 0;
            rd_addr1 = 2'b00; rd_addr2 = 2'b00;
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Simultaneous Dual Port Read");
            reset_dut();
            @(negedge clk);
            we = 1; wr_addr = 2'b01; wr_data = 32'h11112222;
            @(negedge clk);
            we = 1; wr_addr = 2'b10; wr_data = 32'h33334444;
            @(negedge clk);
            we = 0;
            rd_addr1 = 2'b01; rd_addr2 = 2'b10;
            #1;
            #1;

            check_outputs(32'h11112222, 32'h33334444);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Write Enable Verification");
            reset_dut();
            @(negedge clk);
            we = 0; wr_addr = 2'b11; wr_data = 32'hFFFFFFFF;
            @(negedge clk);
            rd_addr1 = 2'b11; rd_addr2 = 2'b00;
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Register Independence Check");
            reset_dut();
            @(negedge clk);
            we = 1; wr_addr = 2'b00; wr_data = 32'hAAAA0000;
            @(negedge clk);
            we = 1; wr_addr = 2'b11; wr_data = 32'h0000BBBB;
            @(negedge clk);
            we = 0;
            rd_addr1 = 2'b00; rd_addr2 = 2'b11;
            #1;
            #1;

            check_outputs(32'hAAAA0000, 32'h0000BBBB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("regfile32bit Testbench");
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
        input [31:0] expected_rd_data1;
        input [31:0] expected_rd_data2;
        begin
            if (expected_rd_data1 === (expected_rd_data1 ^ rd_data1 ^ expected_rd_data1) &&
                expected_rd_data2 === (expected_rd_data2 ^ rd_data2 ^ expected_rd_data2)) begin
                $display("PASS");
                $display("  Outputs: rd_data1=%h, rd_data2=%h",
                         rd_data1, rd_data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_data1=%h, rd_data2=%h",
                         expected_rd_data1, expected_rd_data2);
                $display("  Got:      rd_data1=%h, rd_data2=%h",
                         rd_data1, rd_data2);
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
        $dumpvars(0,clk, rd_addr1, rd_addr2, rst, we, wr_addr, wr_data, rd_data1, rd_data2);
    end

endmodule
