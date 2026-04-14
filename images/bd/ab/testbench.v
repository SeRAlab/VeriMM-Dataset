`timescale 1ns/1ps

module regfile_32bit_8reg_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] read_addr1;
    reg [2:0] read_addr2;
    reg reset;
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
    regfile_32bit_8reg dut (
        .clk(clk),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .reset(reset),
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
        reset = 1;
        write_en = 0;
        write_addr = 0;
        write_data = 0;
        read_addr1 = 0;
        read_addr2 = 0;
        #15;
        reset = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Reset Verification");
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
        $display("Testcase 002: Write to Reg 1 and Read back");
        reset_dut();
        @(posedge clk);
        write_en = 1;
        write_addr = 3'd1;
        write_data = 32'hAAAA_BBBB;
        @(posedge clk);
        write_en = 0;
        read_addr1 = 3'd1;
        read_addr2 = 3'd0;
        #5;
        #1;

        check_outputs(32'hAAAA_BBBB, 32'h0);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Write to Reg 3 and 4, Read both");
        reset_dut();

        @(posedge clk);
        write_en = 1;
        write_addr = 3'd3;
        write_data = 32'h1111_1111;

        @(posedge clk);
        write_addr = 3'd4;
        write_data = 32'h2222_2222;
        @(posedge clk);
        write_en = 0;

        read_addr1 = 3'd3;
        read_addr2 = 3'd4;
        #5;
        #1;

        check_outputs(32'h1111_1111, 32'h2222_2222);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Write Enable (WE=0) Verification");
        reset_dut();
        @(posedge clk);
        write_en = 0;
        write_addr = 3'd5;
        write_data = 32'hFFFF_FFFF;
        @(posedge clk);
        read_addr1 = 3'd5;
        read_addr2 = 3'd0;
        #5;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Overwrite Register 2");
        reset_dut();
        @(posedge clk);
        write_en = 1;
        write_addr = 3'd2;
        write_data = 32'h0000_1234;
        @(posedge clk);
        write_data = 32'h5678_0000;
        @(posedge clk);
        write_en = 0;
        read_addr1 = 3'd2;
        read_addr2 = 3'd2;
        #5;
        #1;

        check_outputs(32'h5678_0000, 32'h5678_0000);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Write to Boundary Register 7");
        reset_dut();
        @(posedge clk);
        write_en = 1;
        write_addr = 3'd7;
        write_data = 32'hDEAD_BEEF;
        @(posedge clk);
        write_en = 0;
        read_addr1 = 3'd7;
        read_addr2 = 3'd0;
        #5;
        #1;

        check_outputs(32'hDEAD_BEEF, 32'h0);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Async Reset Mid-Operation");
        reset_dut();
        @(posedge clk);
        write_en = 1;
        write_addr = 3'd0;
        write_data = 32'hFFFF_FFFF;
        @(posedge clk);
        write_en = 0;

        read_addr1 = 3'd0;
        #5;

        reset = 1;
        #10;
        reset = 0;
        read_addr1 = 3'd0;
        read_addr2 = 3'd0;
        #5;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("regfile_32bit_8reg Testbench");
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
        $dumpvars(0,clk, read_addr1, read_addr2, reset, write_addr, write_data, write_en, read_data1, read_data2);
    end

endmodule
