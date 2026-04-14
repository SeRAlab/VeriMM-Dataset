`timescale 1ns/1ps

module regfile_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] read_addr;
    reg reset;
    reg [1:0] write_addr;
    reg [15:0] write_data;
    reg write_en;
    wire [15:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    regfile dut (
        .clk(clk),
        .read_addr(read_addr),
        .reset(reset),
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
        reset = 1;
        write_en = 0;
        write_addr = 0;
        write_data = 0;
        read_addr = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        read_addr = 2'b00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        write_en = 1;
        write_addr = 2'b01;
        write_data = 16'hA5A5;
        @(posedge clk);
        #1;

        write_en = 0;
        read_addr = 2'b01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hA5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        write_en = 1;
        write_addr = 2'b11;
        write_data = 16'h1234;
        @(posedge clk);
        #1;
        write_en = 0;
        read_addr = 2'b11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        write_en = 0;
        write_addr = 2'b10;
        write_data = 16'hFFFF;
        @(posedge clk);
        #1;
        read_addr = 2'b10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        write_en = 1;
        write_addr = 2'b00;
        write_data = 16'h1111;
        @(posedge clk);
        #1;

        write_data = 16'h2222;
        @(posedge clk);
        #1;
        write_en = 0;
        read_addr = 2'b00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h2222);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();

        write_en = 1;
        write_addr = 2'b01;
        write_data = 16'h7777;
        @(posedge clk);
        #1;

        write_addr = 2'b01;
        write_data = 16'h8888;
        read_addr = 2'b00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("regfile Testbench");
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
        $dumpvars(0,clk, read_addr, reset, write_addr, write_data, write_en, read_data);
    end

endmodule
