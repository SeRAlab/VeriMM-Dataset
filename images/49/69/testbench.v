`timescale 1ns/1ps

module reg_file_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] read_addr1;
    reg [4:0] read_addr2;
    reg we;
    reg [4:0] write_addr;
    reg [31:0] write_data;
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file dut (
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
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write/Read Port 1 & 2");
            reset_dut();
            test_num = 1;


            we = 1;
            write_addr = 5'd1;
            write_data = 32'hABCDE001;
            @(posedge clk);
            #1;


            we = 0;
            read_addr1 = 5'd1;
            read_addr2 = 5'd1;
            #2;

            #1;


            check_outputs(32'hABCDE001, 32'hABCDE001);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Dual Port Read from Different Registers");
            reset_dut();
            test_num = 2;


            we = 1;
            write_addr = 5'd5;
            write_data = 32'h55555555;
            @(posedge clk);
            #1;


            write_addr = 5'd10;
            write_data = 32'hAAAAAAAA;
            @(posedge clk);
            #1;

            we = 0;
            read_addr1 = 5'd5;
            read_addr2 = 5'd10;
            #2;

            #1;


            check_outputs(32'h55555555, 32'hAAAAAAAA);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write Enable Signal Check");
            reset_dut();
            test_num = 3;


            we = 1;
            write_addr = 5'd7;
            write_data = 32'h11111111;
            @(posedge clk);
            #1;


            we = 0;
            write_addr = 5'd7;
            write_data = 32'hEEEEEEEE;
            @(posedge clk);
            #1;

            read_addr1 = 5'd7;
            read_addr2 = 5'd0;
            #2;


            #1;



            check_outputs(32'h11111111, read_data2);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Boundary Check R31");
            reset_dut();
            test_num = 4;

            we = 1;
            write_addr = 5'd31;
            write_data = 32'hFFFFFFFF;
            @(posedge clk);
            #1;

            we = 0;
            read_addr1 = 5'd31;
            read_addr2 = 5'd31;
            #2;

            #1;


            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Overwriting Register");
            reset_dut();
            test_num = 5;


            we = 1;
            write_addr = 5'd15;
            write_data = 32'h12344321;
            @(posedge clk);
            #1;


            write_data = 32'h88889999;
            @(posedge clk);
            #1;

            we = 0;
            read_addr1 = 5'd15;
            read_addr2 = 5'd0;
            #2;

            #1;


            check_outputs(32'h88889999, read_data2);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Register 0 Access");
            reset_dut();
            test_num = 6;

            we = 1;
            write_addr = 5'd0;
            write_data = 32'hDEADBEEF;
            @(posedge clk);
            #1;

            we = 0;
            read_addr1 = 5'd0;
            read_addr2 = 5'd0;
            #2;


            #1;



            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
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
        $dumpvars(0,clk, read_addr1, read_addr2, we, write_addr, write_data, read_data1, read_data2);
    end

endmodule
