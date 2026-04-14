`timescale 1ns/1ps

module reg_file_16x8_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] read_addr1;
    reg [2:0] read_addr2;
    reg rst;
    reg we;
    reg [2:0] write_addr;
    reg [15:0] write_data;
    wire [15:0] read_data1;
    wire [15:0] read_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file_16x8 dut (
        .clk(clk),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .rst(rst),
        .we(we),
        .write_addr(write_addr),
        .write_data(write_data),
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
        we = 0;
        write_addr = 0;
        write_data = 0;
        read_addr1 = 0;
        read_addr2 = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset state check", test_num);
        reset_dut();


        read_addr1 = 3'd0;
        read_addr2 = 3'd7;
        #1;
        #1;

        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Single write and read Port 1", test_num);
        reset_dut();


        we = 1;
        write_addr = 3'd1;
        write_data = 16'hABCD;
        @(posedge clk);
        #1 we = 0;

        read_addr1 = 3'd1;
        read_addr2 = 3'd0;
        #1;
        #1;

        check_outputs(16'hABCD, 16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Single write and read Port 2", test_num);
        reset_dut();


        we = 1;
        write_addr = 3'd5;
        write_data = 16'h1234;
        @(posedge clk);
        #1 we = 0;

        read_addr1 = 3'd0;
        read_addr2 = 3'd5;
        #1;
        #1;

        check_outputs(16'h0000, 16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Write Enable functionality", test_num);
        reset_dut();


        we = 0;
        write_addr = 3'd2;
        write_data = 16'hFFFF;
        @(posedge clk);

        read_addr1 = 3'd2;
        read_addr2 = 3'd0;
        #1;
        #1;

        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Multiple writes and dual read", test_num);
        reset_dut();


        we = 1;
        write_addr = 3'd3;
        write_data = 16'hAAAA;
        @(posedge clk);


        write_addr = 3'd4;
        write_data = 16'h5555;
        @(posedge clk);
        #1 we = 0;

        read_addr1 = 3'd3;
        read_addr2 = 3'd4;
        #1;
        #1;

        check_outputs(16'hAAAA, 16'h5555);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Overwriting data", test_num);
        reset_dut();


        we = 1;
        write_addr = 3'd6;
        write_data = 16'h1111;
        @(posedge clk);


        write_data = 16'h2222;
        @(posedge clk);
        #1 we = 0;

        read_addr1 = 3'd6;
        read_addr2 = 3'd6;
        #1;
        #1;

        check_outputs(16'h2222, 16'h2222);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Boundary check (Register 7)", test_num);
        reset_dut();

        we = 1;
        write_addr = 3'd7;
        write_data = 16'h7777;
        @(posedge clk);
        #1 we = 0;

        read_addr1 = 3'd7;
        read_addr2 = 3'd0;
        #1;
        #1;

        check_outputs(16'h7777, 16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file_16x8 Testbench");
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
        input [15:0] expected_read_data1;
        input [15:0] expected_read_data2;
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
        $dumpvars(0,clk, read_addr1, read_addr2, rst, we, write_addr, write_data, read_data1, read_data2);
    end

endmodule
