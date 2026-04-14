`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] read_address1;
    reg [4:0] read_address2;
    reg [4:0] write_address3;
    reg [31:0] write_data3;
    reg write_enable;
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_address1(read_address1),
        .read_address2(read_address2),
        .write_address3(write_address3),
        .write_data3(write_data3),
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
            @(posedge clk);
            write_enable = 0;
            write_address3 = 0;
            write_data3 = 0;
            read_address1 = 0;
            read_address2 = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Write and Read", test_num);
            reset_dut();


            write_enable = 1;
            write_address3 = 5'd1;
            write_data3 = 32'hDEADBEEF;
            @(posedge clk);
            #1;


            write_enable = 0;
            read_address1 = 5'd1;
            read_address2 = 5'd1;
            #1;

            #1;


            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Register Behavior", test_num);
            reset_dut();


            write_enable = 1;
            write_address3 = 5'd0;
            write_data3 = 32'hFFFFFFFF;
            @(posedge clk);
            #1;


            write_enable = 0;
            read_address1 = 5'd0;
            read_address2 = 5'd0;
            #1;

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Dual Port Read", test_num);
            reset_dut();


            write_enable = 1;
            write_address3 = 5'd10;
            write_data3 = 32'hAAAA_5555;
            @(posedge clk);


            write_address3 = 5'd20;
            write_data3 = 32'h1234_5678;
            @(posedge clk);
            #1;


            write_enable = 0;
            read_address1 = 5'd10;
            read_address2 = 5'd20;
            #1;

            #1;


            check_outputs(32'hAAAA_5555, 32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Write Enable Check", test_num);
            reset_dut();


            write_enable = 1;
            write_address3 = 5'd5;
            write_data3 = 32'h0000_1111;
            @(posedge clk);


            write_enable = 0;
            write_address3 = 5'd5;
            write_data3 = 32'hEEEE_EEEE;
            @(posedge clk);
            #1;


            read_address1 = 5'd5;
            read_address2 = 5'd0;
            #1;

            #1;


            check_outputs(32'h0000_1111, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary Register 31", test_num);
            reset_dut();

            write_enable = 1;
            write_address3 = 5'd31;
            write_data3 = 32'h8765_4321;
            @(posedge clk);
            #1;

            read_address1 = 5'd31;
            read_address2 = 5'd31;
            #1;

            #1;


            check_outputs(32'h8765_4321, 32'h8765_4321);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Concurrent Read and Write", test_num);
            reset_dut();


            write_enable = 1;
            write_address3 = 5'd2;
            write_data3 = 32'h1111_2222;
            @(posedge clk);


            write_address3 = 5'd3;
            write_data3 = 32'h3333_4444;
            read_address1 = 5'd2;
            read_address2 = 5'd2;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h1111_2222, 32'h1111_2222);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        $dumpvars(0,clk, read_address1, read_address2, write_address3, write_data3, write_enable, read_data1, read_data2);
    end

endmodule
