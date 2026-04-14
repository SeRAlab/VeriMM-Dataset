`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr1;
    reg [9:0] addr2;
    reg clk;
    reg [15:0] data_in1;
    reg [15:0] data_in2;
    reg we1;
    reg we2;
    wire [15:0] data_out1;
    wire [15:0] data_out2;

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
            test_num = test_num + 1;
            $display("Test %0d: Basic Port 1 Write/Read", test_num);

            addr1 <= 10'h010;
            data_in1 <= 16'hAAAA;
            we1 <= 1;
            @(posedge clk);
            #1;
            we1 <= 0;


            #1;



            check_outputs(16'hAAAA, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Basic Port 2 Write/Read", test_num);

            addr2 <= 10'h020;
            data_in2 <= 16'h5555;
            we2 <= 1;
            @(posedge clk);
            #1;
            we2 <= 0;


            #1;



            check_outputs(16'h0000, 16'h5555);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Simultaneous Writes", test_num);

            addr1 <= 10'h031; data_in1 <= 16'h1111; we1 <= 1;
            addr2 <= 10'h032; data_in2 <= 16'h2222; we2 <= 1;
            @(posedge clk);
            #1;
            we1 <= 0; we2 <= 0;

            #1;


            check_outputs(16'h1111, 16'h2222);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Cross Port Reading", test_num);


            addr1 <= 10'h064; data_in1 <= 16'hBEEF; we1 <= 1;
            @(posedge clk);
            #1;
            we1 <= 0;


            addr2 <= 10'h064;
            #1;
            #1;

            check_outputs(16'hBEEF, 16'hBEEF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Write Enable Low Verification", test_num);


            addr1 <= 10'h005; data_in1 <= 16'h7777; we1 <= 1;
            @(posedge clk);
            #1;


            we1 <= 0; data_in1 <= 16'hFFFF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h7777, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Simultaneous Read Same Address", test_num);


            addr1 <= 10'h005; data_in1 <= 16'h1234; we1 <= 1;
            @(posedge clk);
            #1;
            we1 <= 0;


            addr1 <= 10'h005;
            addr2 <= 10'h005;
            #1;
            #1;

            check_outputs(16'h1234, 16'h1234);
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
        input [15:0] expected_data_out1;
        input [15:0] expected_data_out2;
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
        $dumpvars(0,addr1, addr2, clk, data_in1, data_in2, we1, we2, data_out1, data_out2);
    end

endmodule
