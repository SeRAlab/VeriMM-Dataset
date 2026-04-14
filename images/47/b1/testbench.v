`timescale 1ns/1ps

module reg_file_32x32_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] read_addr1;
    reg [4:0] read_addr2;
    reg [4:0] write_addr;
    reg [31:0] write_data;
    reg write_enable;
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file_32x32 dut (
        .clk(clk),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_enable(write_enable),
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
            read_addr1 = 0;
            read_addr2 = 0;
            write_addr = 0;
            write_data = 0;
            write_enable = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Basic Write and Dual Port Read", test_num);


            write_addr = 5;
            write_data = 32'hDEADBEEF;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_addr1 = 5;
            read_addr2 = 5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Independent Simultaneous Reads", test_num);


            write_addr = 10;
            write_data = 32'h12345678;
            write_enable = 1;
            @(posedge clk);
            #1;


            write_addr = 20;
            write_data = 32'h87654321;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_addr1 = 10;
            read_addr2 = 20;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h12345678, 32'h87654321);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Write Enable Verification", test_num);


            write_addr = 15;
            write_data = 32'hAAAA_AAAA;
            write_enable = 1;
            @(posedge clk);
            #1;


            write_addr = 15;
            write_data = 32'hBBBB_BBBB;
            write_enable = 0;
            @(posedge clk);
            #1;


            read_addr1 = 15;
            read_addr2 = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hAAAA_AAAA, 32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Boundary Address Check (0 and 31)", test_num);


            write_addr = 0;
            write_data = 32'hF0F0_F0F0;
            write_enable = 1;
            @(posedge clk);
            #1;


            write_addr = 31;
            write_data = 32'h0F0F_0F0F;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_addr1 = 0;
            read_addr2 = 31;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hF0F0_F0F0, 32'h0F0F_0F0F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Overwrite check", test_num);

            write_addr = 7;
            write_data = 32'h1;
            write_enable = 1;
            @(posedge clk);
            #1;

            write_addr = 7;
            write_data = 32'hFFFF_FFFF;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;

            read_addr1 = 7;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFF_FFFF, 32'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file_32x32 Testbench");
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
        $dumpvars(0,clk, read_addr1, read_addr2, write_addr, write_data, write_enable, read_data1, read_data2);
    end

endmodule
