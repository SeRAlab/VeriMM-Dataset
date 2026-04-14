`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr1;
    reg [9:0] addr2;
    reg clk;
    reg [7:0] data_in1;
    reg [7:0] data_in2;
    reg re1;
    reg re2;
    reg we1;
    reg we2;
    wire [7:0] data_out1;
    wire [7:0] data_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr1(addr1),
        .addr2(addr2),
        .clk(clk),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .re1(re1),
        .re2(re2),
        .we1(we1),
        .we2(we2),
        .data_out1(data_out1),
        .data_out2(data_out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we1 = 0;
            we2 = 0;
            re1 = 0;
            re2 = 0;
            addr1 = 0;
            addr2 = 0;
            data_in1 = 0;
            data_in2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Port 1 Basic Write/Read", test_num);


            we1 = 1; addr1 = 10'd10; data_in1 = 8'hA5;
            @(posedge clk); #1;


            we1 = 0; re1 = 1; addr1 = 10'd10;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hA5, 8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Port 2 Basic Write/Read", test_num);


            we2 = 1; addr2 = 10'd20; data_in2 = 8'h5A;
            @(posedge clk); #1;


            we2 = 0; re2 = 1; addr2 = 10'd20;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h00, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Simultaneous Write to Different Addrs", test_num);


            we1 = 1; addr1 = 10'd100; data_in1 = 8'h11;
            we2 = 1; addr2 = 10'd200; data_in2 = 8'h22;
            @(posedge clk); #1;


            we1 = 0; we2 = 0;
            re1 = 1; addr1 = 10'd100;
            re2 = 1; addr2 = 10'd200;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Read Enable logic (RE=0 results in 0)", test_num);


            we1 = 1; addr1 = 10'd500; data_in1 = 8'hFF;
            @(posedge clk); #1;


            we1 = 0; re1 = 0; addr1 = 10'd500;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Simultaneous Read from same Address", test_num);


            we1 = 1; addr1 = 10'd777; data_in1 = 8'h77;
            @(posedge clk); #1;


            we1 = 0; re1 = 1; addr1 = 10'd777;
            re2 = 1; addr2 = 10'd777;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h77, 8'h77);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Simultaneous Write (P1) and Read (P2)", test_num);


            we1 = 1; addr1 = 10'd30; data_in1 = 8'h33;
            @(posedge clk); #1;


            we1 = 1; addr1 = 10'd40; data_in1 = 8'h44;
            re2 = 1; addr2 = 10'd30;
            @(posedge clk); #1;


            we1 = 0;
            #1;

            check_outputs(8'h00, 8'h33);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Boundary Address Check (1023)", test_num);

            we1 = 1; addr1 = 10'd1023; data_in1 = 8'hBE;
            @(posedge clk); #1;

            we1 = 0; re1 = 1; addr1 = 10'd1023;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hBE, 8'h00);
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
        input [7:0] expected_data_out1;
        input [7:0] expected_data_out2;
        begin
            if (expected_data_out1 === (expected_data_out1 ^ data_out1 ^ expected_data_out1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2)) begin
                $display("PASS");
                $display("  Outputs: data_out1=%h, data_out2=%h",
                         data_out1, data_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out1=%h, data_out2=%h",
                         expected_data_out1, expected_data_out2);
                $display("  Got:      data_out1=%h, data_out2=%h",
                         data_out1, data_out2);
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
        $dumpvars(0,addr1, addr2, clk, data_in1, data_in2, re1, re2, we1, we2, data_out1, data_out2);
    end

endmodule
