`timescale 1ns/1ps

module register_file_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] read_addr1;
    reg [2:0] read_addr2;
    reg we;
    reg [2:0] write_addr;
    reg [7:0] write_data;
    wire [7:0] read_data1;
    wire [7:0] read_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_file dut (
        .clk(clk),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
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
        we = 0;
        write_addr = 0;
        write_data = 0;
        read_addr1 = 0;
        read_addr2 = 0;

        for (integer i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
            we = 1;
            write_addr = i;
            write_data = 8'h00;
        end
        @(posedge clk);
        we = 0;
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Basic Write and Dual Read", test_num);
        reset_dut();

        @(posedge clk);
        we = 1;
        write_addr = 3'd2;
        write_data = 8'hAA;
        @(posedge clk);
        we = 0;

        read_addr1 = 3'd2;
        read_addr2 = 3'd2;
        #2;
        #1;

        check_outputs(8'hAA, 8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Multiple Register Write/Read", test_num);
        reset_dut();


        @(posedge clk);
        we = 1; write_addr = 3'd1; write_data = 8'h11;

        @(posedge clk);
        we = 1; write_addr = 3'd5; write_data = 8'h55;
        @(posedge clk);
        we = 0;

        read_addr1 = 3'd1;
        read_addr2 = 3'd5;
        #2;
        #1;

        check_outputs(8'h11, 8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Write Enable Verification", test_num);
        reset_dut();


        @(posedge clk);
        we = 1; write_addr = 3'd4; write_data = 8'h44;
        @(posedge clk);

        we = 0; write_addr = 3'd4; write_data = 8'hFF;
        @(posedge clk);

        read_addr1 = 3'd4;
        read_addr2 = 3'd0;
        #2;
        #1;

        check_outputs(8'h44, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Overwrite Register", test_num);
        reset_dut();

        @(posedge clk);
        we = 1; write_addr = 3'd6; write_data = 8'h66;
        @(posedge clk);
        we = 1; write_addr = 3'd6; write_data = 8'h99;
        @(posedge clk);
        we = 0;

        read_addr1 = 3'd6;
        read_addr2 = 3'd6;
        #2;
        #1;

        check_outputs(8'h99, 8'h99);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Boundary Addresses (0 and 7)", test_num);
        reset_dut();

        @(posedge clk);
        we = 1; write_addr = 3'd0; write_data = 8'h01;
        @(posedge clk);
        we = 1; write_addr = 3'd7; write_data = 8'h07;
        @(posedge clk);
        we = 0;

        read_addr1 = 3'd0;
        read_addr2 = 3'd7;
        #2;
        #1;

        check_outputs(8'h01, 8'h07);
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
        input [7:0] expected_read_data1;
        input [7:0] expected_read_data2;
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
        $dumpvars(0,clk, read_addr1, read_addr2, we, write_addr, write_data, read_data1, read_data2);
    end

endmodule
