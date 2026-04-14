`timescale 1ns/1ps

module reg_file_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] read_addr1;
    reg [2:0] read_addr2;
    reg rst;
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
    reg_file_32bit dut (
        .clk(clk),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .rst(rst),
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
            rst = 1;
            clk = 0;
            read_addr1 = 0;
            read_addr2 = 0;
            write_addr = 0;
            write_data = 0;
            write_en = 0;
            #15;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write and Dual Read (Reg 1 and 2)", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1;
            write_addr = 3'd1;
            write_data = 32'hAAAA_BBBB;


            @(posedge clk);
            write_addr = 3'd2;
            write_data = 32'hCCCC_DDDD;

            @(posedge clk);
            write_en = 0;


            read_addr1 = 3'd1;
            read_addr2 = 3'd2;

            #2;
            #1;

            check_outputs(32'hAAAA_BBBB, 32'hCCCC_DDDD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write to Boundary Registers (Reg 0 and 7)", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1;
            write_addr = 3'd0;
            write_data = 32'h1234_5678;


            @(posedge clk);
            write_addr = 3'd7;
            write_data = 32'hFEDC_BA98;

            @(posedge clk);
            write_en = 0;

            read_addr1 = 3'd0;
            read_addr2 = 3'd7;

            #2;
            #1;

            check_outputs(32'h1234_5678, 32'hFEDC_BA98);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify Write Enable (Disable check)", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1;
            write_addr = 3'd3;
            write_data = 32'h5555_AAAA;


            @(posedge clk);
            write_en = 0;
            write_addr = 3'd3;
            write_data = 32'hFFFF_FFFF;

            @(posedge clk);
            read_addr1 = 3'd3;
            read_addr2 = 3'd0;

            #2;

            #1;


            check_outputs(32'h5555_AAAA, 32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Dual Read from Same Register", test_num);
            reset_dut();

            @(posedge clk);
            write_en = 1;
            write_addr = 3'd4;
            write_data = 32'hBEEF_CAFE;

            @(posedge clk);
            write_en = 0;
            read_addr1 = 3'd4;
            read_addr2 = 3'd4;

            #2;
            #1;

            check_outputs(32'hBEEF_CAFE, 32'hBEEF_CAFE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Asynchronous Reset Verification", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1;
            write_addr = 3'd5;
            write_data = 32'hFFFF_0000;

            @(posedge clk);
            write_en = 0;
            read_addr1 = 3'd5;
            #1;


            rst = 1;
            #5;
            rst = 0;
            #5;

            read_addr1 = 3'd5;
            read_addr2 = 3'd5;

            #2;

            #1;


            check_outputs(32'h0000_0000, 32'h0000_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file_32bit Testbench");
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
        $dumpvars(0,clk, read_addr1, read_addr2, rst, write_addr, write_data, write_en, read_data1, read_data2);
    end

endmodule
