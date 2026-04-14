`timescale 1ns/1ps

module regfile_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] read_addr1;
    reg [2:0] read_addr2;
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
    regfile_16bit dut (
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

        integer i;
        begin
            @(negedge clk);
            we = 1;
            for (i = 0; i < 8; i = i + 1) begin
                write_addr = i;
                write_data = 16'h0000;
                @(negedge clk);
            end
            we = 0;
            write_addr = 0;
            write_data = 0;
            read_addr1 = 0;
            read_addr2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read (Register 3)");
            reset_dut();

            @(negedge clk);
            we = 1;
            write_addr = 3'd3;
            write_data = 16'hABCD;
            @(negedge clk);
            we = 0;

            read_addr1 = 3'd3;
            read_addr2 = 3'd0;
            #2;
            #1;

            check_outputs(16'hABCD, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Dual Port Read after Multiple Writes");
            reset_dut();

            @(negedge clk);
            we = 1;
            write_addr = 3'd1;
            write_data = 16'h1111;
            @(negedge clk);

            write_addr = 3'd2;
            write_data = 16'h2222;
            @(negedge clk);
            we = 0;

            read_addr1 = 3'd1;
            read_addr2 = 3'd2;
            #2;
            #1;

            check_outputs(16'h1111, 16'h2222);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write Enable (WE) Inactive Check");
            reset_dut();

            @(negedge clk);
            we = 0;
            write_addr = 3'd5;
            write_data = 16'hFFFF;
            @(negedge clk);

            read_addr1 = 3'd5;
            read_addr2 = 3'd5;
            #2;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Boundary Registers (Reg 0 and Reg 7)");
            reset_dut();

            @(negedge clk);
            we = 1;
            write_addr = 3'd0;
            write_data = 16'hA5A5;
            @(negedge clk);

            write_addr = 3'd7;
            write_data = 16'h5A5A;
            @(negedge clk);
            we = 0;

            read_addr1 = 3'd0;
            read_addr2 = 3'd7;
            #2;
            #1;

            check_outputs(16'hA5A5, 16'h5A5A);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwriting an existing value");
            reset_dut();

            @(negedge clk);
            we = 1;
            write_addr = 3'd4;
            write_data = 16'h1234;
            @(negedge clk);

            write_addr = 3'd4;
            write_data = 16'hEDCB;
            @(negedge clk);
            we = 0;

            read_addr1 = 3'd4;
            read_addr2 = 3'd4;
            #2;
            #1;

            check_outputs(16'hEDCB, 16'hEDCB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("regfile_16bit Testbench");
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
        $dumpvars(0,clk, read_addr1, read_addr2, we, write_addr, write_data, read_data1, read_data2);
    end

endmodule
